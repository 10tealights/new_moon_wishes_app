FactoryBot.define do
  factory :declaration do
    wish { nil }
    message { 'MyString' }
    come_true { 1 }
    is_shared { false }
  end
end
