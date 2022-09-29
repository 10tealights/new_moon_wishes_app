class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :wishes, dependent: :destroy
  has_many :cheers, dependent: :destroy
  has_many :cheered_declarations, through: :cheers, source: :declaration
  # 現状LINEログインしか想定していないが、今後変更の可能性もあるためWiki通りhas_manyアソシエーションにて設定
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true, length: { maximum: 30 }
  validates :account_id, presence: true, uniqueness: true, length: { maximum: 30 }

  validates :password, length: { minimum: 7 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def cheered?(declaration)
    cheered_declarations.map(&:id).include?(declaration.id)
  end

  def self.guest_generate
    random_value = SecureRandom.hex(3)
    User.find_or_create_by!(name: 'GUEST', account_id: "guest_#{random_value}", email: "guest_#{random_value}@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
    end
  end
end
