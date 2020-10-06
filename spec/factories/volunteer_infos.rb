FactoryBot.define do
  factory :volunteer_info do
    address { brazilian_address }
    city { Faker::Address.city }
    state { state_creator }
    instagram { Faker::Lorem.characters(number: 25) }
    facebook { Faker::Lorem.characters(number: 25) }
    lattes { Faker::Lorem.characters(number: 25) }
    institution { Faker::Lorem.characters(number: 25) }
    degree { Faker::Lorem.characters(number: 25) }
    unemat_bond { bond_generator }
    user { association :volunteer }

    trait :pending do
      user { association :pending_volunteer }
    end

    trait :mod do
      user { association :moderator }
    end

    trait :adm do
      user { association :administrator }
    end

    factory :pending_volunteer_info, traits: [:pending]
    factory :adm_info, traits: [:adm]
    factory :mod_info, traits: [:mod]
  end
end

def bond_generator
  bond = ['Professor', 'Aluno', 'Colaborador Externo']
  bond[Faker::Number.between(from: 0, to: 2)]
end
