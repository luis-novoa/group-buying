FactoryBot.define do
  factory :purchase do
    active { true }
    status { create_status }
    total { Faker::Number.decimal(l_digits: 2, r_digits: 4) }
    partner { association :partner }

    trait :inactive do
      active { false }
    end

    factory :inactive_purchase, traits: [:inactive]
  end
end

def create_status
  status = ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada']
  status[Faker::Number.between(from: 0, to: 3)]
end
