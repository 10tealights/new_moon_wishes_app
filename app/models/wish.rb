class Wish < ApplicationRecord
  has_many :declarations, dependent: :destroy
  belongs_to :user
  belongs_to :moon
  # delegate :zodiac_sign, to: :moon
  has_one :zodiac_sign, through: :moon

  validates :moon_id, uniqueness: { scope: :user_id }
end
