FactoryBot.define do
  factory :partner do
    name { Faker::Name.name }
    official_name { Faker::Name.name }
    cnpj { cnpj_generator }
    description { Faker::Lorem.characters(number: 150) }
    website { Faker::Lorem.characters(number: 25) }
    email { Faker::Internet.email }
    phone1 { phone_creator }
    phone1_type { phone_type_creator }
    phone2 { phone_creator }
    phone2_type { phone_type_creator }
    address { brazilian_address }
    city { Faker::Address.city }
    state { state_creator }
    supplier { true }
    partner_page { false }
    user { nil }

    trait :delivery_type do
      supplier { false }
      user { association :delivery }
    end

    factory :partner_user, traits: [:delivery_type]
  end
end

def cnpj_generator
  "#{Faker::Number.number(digits: 2)}.#{Faker::Number.number(digits: 3)}." \
    "#{Faker::Number.number(digits: 3)}/#{Faker::Number.number(digits: 4)}-" +
    Faker::Number.number(digits: 2).to_s
end
