FactoryBot.define do
  factory :payment do
    user { association :user }
  end
end
