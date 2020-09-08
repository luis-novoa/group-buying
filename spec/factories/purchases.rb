FactoryBot.define do
  factory :purchase do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    limited_quantity { false }
    quantity { 0 }
    active { true }
    status { create_status }
    total { Faker::Number.decimal(l_digits: 2, r_digits: 4) }
    message { nil }
    product_id { create(:product).id }
    # product { association :product }
  end
end

def create_status
  status = ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada']
  status[Faker::Number.between(from: 0, to: 3)]
end
