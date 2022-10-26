class ZodiacSign < ApplicationRecord
  has_many :moons
  has_many :wishes, through: :moons
  has_many :traits

  validates :name, presence: true, uniqueness: true

  enum name: {
    aries: 0,
    taurus: 1,
    gemini: 2,
    cancer: 3,
    leo: 4,
    virgo: 5,
    libra: 6,
    scorpio: 7,
    sagittarius: 8,
    capricorn: 9,
    aquarius: 10,
    pisces: 11
  }
end
