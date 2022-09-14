class DeclarationTag < ApplicationRecord
  belongs_to :declaration_id
  belongs_to :tag_id

  validates :tag_id, uniqueness: { scope: :declaration_id }
end
