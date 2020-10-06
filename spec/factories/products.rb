FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    weigth { Faker::Number.between(from: 1, to: 1000) }
    description { Faker::Lorem.characters(number: 150) }
    partner { association :partner }
  end
end
