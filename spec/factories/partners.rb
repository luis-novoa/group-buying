FactoryBot.define do
  factory :partner do
    name { Faker::Name.name }
    official_name { Faker::Name.name }
    cnpj { Faker::Number.number(digits: 14) }
    description { Faker::Lorem.characters(number: 150) }
    website { Faker::Lorem.characters(number: 25) }
    email { Faker::Internet.email }
    ddd1 { Faker::Number.between(from: 11, to: 99) }
    phone1 { Faker::Number.number(digits: 9) }
    phone1_type { phone_type_creator }
    ddd2 { Faker::Number.between(from: 11, to: 99) }
    phone2 { Faker::Number.number(digits: 9) }
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
