FactoryBot.define do
  factory :payment do
    code { 'TESTCODE' }
    user { association :user }
  end
end
