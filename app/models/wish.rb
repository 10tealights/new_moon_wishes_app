class Wish < ApplicationRecord
  has_many :declarations, dependent: :destroy
  belongs_to :user
  belongs_to :moon

  validates :moon_id, uniqueness: { scope: :user_id }
end
