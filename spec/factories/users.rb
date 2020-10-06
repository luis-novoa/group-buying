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
    waiting_approval { false }
    super_user { false }
    moderator { false }
    cpf { generate_cpf }

    trait :volunteer_type do
      account_type { 'Voluntário' }
    end

    trait :deliver_type do
      account_type { 'Ponto de Entrega' }
    end

    trait :pending do
      waiting_approval { true }
    end

    trait :mod do
      moderator { true }
    end

    trait :adm do
      super_user { true }
    end

    factory :volunteer, traits: %i[volunteer_type]
    factory :moderator, traits: %i[volunteer_type mod]
    factory :administrator, traits: %i[volunteer_type adm mod]
    factory :pending_volunteer, traits: %i[volunteer_type pending]
    factory :delivery, traits: %i[deliver_type]
    factory :pending_delivery, traits: %i[deliver_type pending]
  end
end
