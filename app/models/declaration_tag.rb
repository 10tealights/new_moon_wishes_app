class DeclarationTag < ApplicationRecord
  belongs_to :declaration
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :declaration_id }
end
