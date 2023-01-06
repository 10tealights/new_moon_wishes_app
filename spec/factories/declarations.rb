FactoryBot.define do
  factory :declaration do
    wish { nil }
    sequence(:message, 'test_declaration_message_1')
    come_true { 0 }
    is_shared { true }

    trait :add_wish do
      wish
    end
  end
end
