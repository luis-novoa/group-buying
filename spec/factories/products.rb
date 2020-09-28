FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    short_description { Faker::Lorem.characters(number: 50) }
    description { Faker::Lorem.characters(number: 150) }
    partner { association :partner }
  end
end
