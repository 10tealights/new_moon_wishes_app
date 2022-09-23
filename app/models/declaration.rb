class Declaration < ApplicationRecord
  belongs_to :wish, optional: true
  has_many :declaration_tags, dependent: :destroy
  has_many :tags, through: :declaration_tags, source: :tag

  validates :message, length: { maximum: 100 }
  validates :come_true, presence: true
  validates :is_shared, inclusion: [true, false]
  validates :wish_id, presence: true

  enum come_true: { wished: 0, fulfilled: 1, removed: 2 }
end
