class Declaration < ApplicationRecord
  belongs_to :wish, optional: true
  has_many :declaration_tags, dependent: :destroy
  has_many :tags, through: :declaration_tags, source: :tag
  has_many :cheers
  has_many :cheered_users, through: :cheers, source: :user

  validates :message, length: { maximum: 100 }
  validates :come_true, presence: true
  validates :is_shared, inclusion: [true, false]
  validates :wish_id, presence: true

  enum come_true: { wished: 0, fulfilled: 1, removed: 2 }

  scope :shared_other_declarations, ->(current_user, declaration_status) { order(created_at: :desc).where.not(user: { id: current_user.id }).where(come_true: declaration_status).where(is_shared: 'true') }
end
