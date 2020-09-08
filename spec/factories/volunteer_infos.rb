FactoryBot.define do
  factory :volunteer_info do
    instagram { Faker::Lorem.characters(number: 25) }
    facebook { Faker::Lorem.characters(number: 25) }
    lattes { Faker::Lorem.characters(number: 25) }
    institution { Faker::Lorem.characters(number: 25) }
    degree { Faker::Lorem.characters(number: 25) }
    unemat_bond { bond_generator }
    user { association :user }
  end
end

def bond_generator
  bond = ['Professor', 'Aluno', 'Colaborador Externo']
  bond[Faker::Number.between(from: 0, to: 2)]
end
