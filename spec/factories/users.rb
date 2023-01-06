FactoryBot.define do
  factory :user do
    sequence(:name, 'test_user_1')
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
