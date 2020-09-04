FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    description { Faker::Lorem.characters(number: 150) }
    partner_id { create(:partner).id }
  end
end
