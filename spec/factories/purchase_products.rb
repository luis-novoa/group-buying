FactoryBot.define do
  factory :purchase_product do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    quantity { Faker::Number.between(from: 100, to: 1000) }
    offer_city { 'Ambas' }
    purchase { association :purchase }
    product { association :product }
  end
end
