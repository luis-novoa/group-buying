require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 6) }
    password_confirmation { password }
    address { brazilian_address }
    city { Faker::Address.city }
    state { state_creator }
    phone1 { phone_creator }
    phone1_type { phone_type_creator }
    phone2 { phone_creator }
    phone2_type { phone_type_creator }
    account_type { 'Comprador' }

    trait :volunteer_type do
      account_type { 'Voluntário' }
    end

    trait :deliver_type do
      account_type { 'Ponto de Entrega' }
    end

    factory :volunteer, traits: [:volunteer_type]
    factory :delivery, traits: [:deliver_type]
  end
end
