class Tag < ApplicationRecord
  has_many :declaration_tags, dependent: :destroy
  has_many :tagged_declarations, through: :declaration_tags, source: :declaration

  validates :name, presence: true, length: { maximum: 15 }
end
