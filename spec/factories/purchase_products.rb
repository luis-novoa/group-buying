FactoryBot.define do
  factory :purchase_product do
    name { product.name }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 3) }
    quantity { Faker::Number.between(from: 100, to: 1000) }
    offer_city { 'Sinop e Cuiabá' }
    purchase { association :purchase }
    product { association :product }

    trait :inactive do
      purchase { association :inactive_purchase }
    end

    factory :inactive_purchase_product, traits: [:inactive]
  end
end
