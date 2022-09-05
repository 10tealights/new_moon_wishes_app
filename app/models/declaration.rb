class Declaration < ApplicationRecord
  belongs_to :wish

  validates :message, presence: true
  validates :come_true, presence: true
  validates :is_shared, inclusion: [true, false]

  enum come_true: { wished: 0, fulfilled: 1, removed: 2 }
end
