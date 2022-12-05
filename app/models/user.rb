class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :wishes, dependent: :destroy
  has_many :cheers, dependent: :destroy
  has_many :cheered_declarations, through: :cheers, source: :declaration
  # 現状LINEログインしか想定していないが、今後変更の可能性もあるためWiki通りhas_manyアソシエーションにて設定
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, on: %i[create update]
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze }, uniqueness: true 
  validates :password, length: { minimum: 7 }, format: { with: /\A[a-zA-Z0-9]+\z/.freeze }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general: 0, admin: 1 }

  def cheered?(declaration)
    cheered_declarations.map(&:id).include?(declaration.id)
  end

  def self.guest_generate
    random_value = SecureRandom.hex(3)
    User.find_or_create_by!(name: 'GUEST', email: "guest_#{random_value}@example.com") do |user|
      user.password = SecureRandom.alphanumeric(14)
      user.password_confirmation = user.password
    end
  end

  def change_notification_status(params)
    if params[:need_newmoon_msg]
      self.need_newmoon_msg = params[:need_newmoon_msg].include?('true') ? :true : :false
    elsif params[:need_fullmoon_msg]
      self.need_fullmoon_msg = params[:need_fullmoon_msg].include?('true') ? :true : :false
    end
    self.save(validate: false)
  end
end
