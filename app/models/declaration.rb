class Declaration < ApplicationRecord
  belongs_to :wish, optional: true
  has_many :declaration_tags, dependent: :destroy

  validates :message, length: { maximum: 100 }
  validates :come_true, presence: true
  validates :is_shared, inclusion: [true, false]
  validates :wish_id, presence: true, unless: :declaration_form?

  enum come_true: { wished: 0, fulfilled: 1, removed: 2 }

  def declaration_form?
    validation_context == :declaration_form
  end
end
