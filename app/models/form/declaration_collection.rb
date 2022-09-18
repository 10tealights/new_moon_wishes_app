class Form::DeclarationCollection
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  DEFAULT_ITEM_COUNT = 2

  attr_accessor :declarations, :declaration_tags

  validate :less_than_two_declarations?

  def initialize(current_user = nil, attributes = {})
    @current_user = current_user
    self.declarations = DEFAULT_ITEM_COUNT.times.map { Declaration.new } unless declarations.present?
    super(attributes)
  end

  def declarations_attributes=(attributes)
    self.declarations = attributes.map do |_, attribute|
      if attribute[:declaration_tags].present?
        declaration = Declaration.new(attribute.except(:declaration_tags))
        declaration.tag_ids = attribute[:declaration_tags].map(&:to_i)
        declaration
      else
        Declaration.new(attribute)
      end
    end
  end

  def save
    return false unless wish_is_not_created?

    ActiveRecord::Base.transaction do
      @wish.save!
      declarations.each do |declaration|
        next if declaration.message.blank?

        declaration.wish_id = @wish.id
        return false if invalid?

        # Tagについてもここで同時に保存される
        declaration.save!
      end
      true
    end
    rescue ActiveRecord::RecordInvalid => e
    p e
    false
  end

  private

  def wish_is_not_created?
    latest_newmoon = Moon.latest
    @wish = @current_user.wishes.find_by(moon_id: latest_newmoon.id)
    if @wish.nil?
      @wish = @current_user.wishes.build(moon_id: latest_newmoon.id)
      true
    else
      errors.add(:base, "今回の#{latest_newmoon.zodiac_sign.name}新月の願いごとはすでに宣言されています")
      false
    end
  end

  def less_than_two_declarations?
    if declarations.pluck(:message).compact_blank.size < 2
      errors.add(:base, '願いごとは2個以上で宣言してください')
      false
    end
  end
end
