class Cheer < ApplicationRecord
  belongs_to :user
  belongs_to :declaration

  validates :user_id, uniqueness: { scope: :declaration_id }
end
