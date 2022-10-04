class Moon < ApplicationRecord
  has_many :wishes
  has_many :wished_users , through: :wishes, source: :user
  belongs_to :zodiac_sign

  validates :newmoon_time, presence: true
  validates :fullmoon_time, presence: true

  def self.latest
    latest_moon = find_by(newmoon_time: Time.current.ago(2.days)..Time.current)
    latest_moon.present? ? latest_moon : find_by(newmoon_time: Time.current..Time.current + 29.day + 12.hours)
  end
end
