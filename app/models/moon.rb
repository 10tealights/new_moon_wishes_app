class Moon < ApplicationRecord
  belongs_to :zodiac_sign

  validates :newmoon_time, presence: true
  validates :fullmoon_time, presence: true
end
