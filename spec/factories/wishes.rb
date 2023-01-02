FactoryBot.define do
  factory :wish do
    moon { Moon.latest }
    memo { nil }
    user
  end
end
