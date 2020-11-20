FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    weight { Faker::Number.between(from: 1, to: 1000) }
    weight_type { 'g' }
    description { Faker::Lorem.characters(number: 150) }
    partner { association :partner }
  end
end
