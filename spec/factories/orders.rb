FactoryBot.define do
  factory :order do
    quantity { Faker::Number.between(from: 1, to: 100) }
    total { purchase_product.price * quantity }
    status { 'Carrinho' }
    delivery_city { 'Sinop' }
    user { association :user }
    purchase_product { association :purchase_product }
  end
end
