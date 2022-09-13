class Form::DeclarationCollection < Form::Base
  include ActiveModel::Attributes

  DEFAULT_ITEM_COUNT = 5
  attr_accessor :wish, :declarations

  validate :wish_is_not_created?
  validate :declaration_validate

  def initialize(current_user = nil, attributes = {})
    super(attributes)
    @current_user = current_user
    self.declarations = DEFAULT_ITEM_COUNT.times.map { Form::Declaration.new } unless declarations.present?
  end

  def declarations_attributes=(attributes)
    self.declarations = attributes.map do |_, declaration_attributes|
      Form::Declaration.new(declaration_attributes)
    end
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @wish.save
      declarations.each do |declaration|
        next if declaration.message.blank?

        declaration.wish_id = @wish.id
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
    @wish = @current_user.wishes.find_by(moon_id: 2)
    if @wish.nil?
      @wish = @current_user.wishes.build(moon_id: 2)
      true
    else
      errors.add(:base, '今回の新月の願いごとはすでに宣言されています')
      false
    end
  end

  def less_than_two_declarations?
    if declarations.pluck(:message).compact_blank.size < 2
      errors.add(:base, '願いごとは2個以上で宣言してください')
      true
    end
  end

  def declaration_validate
    return false if less_than_two_declarations?

    results = declarations.map { |declaration| declaration.valid?(:declaration_form) }
    results.all?
  end
end
