FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    description { Faker::Lorem.characters(number: 150) }
    partner { '' }
  end
end
