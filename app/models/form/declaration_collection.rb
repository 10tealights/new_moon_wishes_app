class Form::DeclarationCollection
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  DEFAULT_ITEM_COUNT = 10

  attr_accessor :wish, :memo, :declarations

  delegate :persisted?, to: :@wish

  validate :less_than_two_declarations?

  def initialize(current_user = nil, attributes = {}, wish: Wish.new)
    @current_user = current_user
    @wish = wish
    self.declarations = @wish.declarations.present? ? @wish.declarations : DEFAULT_ITEM_COUNT.times.map { Declaration.new }
    super(attributes)
  end

  def declarations_attributes=(attributes)
    self.declarations = attributes.map do |_i, attribute|
                          if attribute['id'].nil?
                            declaration = Declaration.new(attribute.except(:declaration_tags))
                            declaration.tag_ids = attribute[:declaration_tags][:tag_id].map(&:to_i) if attribute[:declaration_tags].present?
                          else
                            declaration = @wish.declarations.find(attribute[:id].to_i)
                            declaration.assign_attributes(attribute.except(:declaration_tags))
                          end
                          declaration
                        end
  end

  def save
    return false unless wish_is_not_created? && valid?
    ActiveRecord::Base.transaction do
      @wish.save!
      declarations.each do |declaration|
        next if declaration.message.blank?

        declaration.wish_id = @wish.id
        return false unless declaration.valid?
      end
      declarations.each(&:save!)
      true
    end
    rescue ActiveRecord::RecordInvalid => e
    p e
    false
  end

  def update(tag_params)
    return false unless valid?

    ActiveRecord::Base.transaction do
      if tag_params[:memo].present?
        declarations.each(&:save!)
        @wish.update!(memo: tag_params[:memo])
      else
        declarations.each_with_index do |declaration, index|
          next if declaration.message.blank?

          if tag_params[index.to_s][:declaration_tags].present?
            tags = tag_params[index.to_s][:declaration_tags][:tag_id].map(&:to_i)
            declaration.tag_ids = tags
          else
            declaration.tag_ids = []
          end
          return false unless declaration.valid?
        end
        declarations.each(&:save!)
      end
      true
    end
  rescue ActiveRecord::RecordInvalid => e
    p e
    false
  end

  def to_model
    @wish
  end

  private

  def wish_is_not_created?
    latest_newmoon = Moon.latest
    wish = @current_user.wishes.find_by(moon_id: latest_newmoon.id)
    if wish.nil?
      @wish.assign_attributes(user_id: @current_user.id, moon_id: latest_newmoon.id)
      true
    else
      errors.add(:base, "今回の#{latest_newmoon.zodiac_sign.name_i18n}新月の願いごとはすでに宣言されています")
      false
    end
  end

  def less_than_two_declarations?
    if declarations.pluck(:message).compact_blank.size < 2
      errors.add(:base, '願いごとは2〜10個で宣言してください')
      false
    end
  end
end
