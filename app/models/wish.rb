class Wish < ApplicationRecord
  belongs_to :user
  belongs_to :moon

  validates :moon_id, uniqueness: { scope: :user_id }
end
