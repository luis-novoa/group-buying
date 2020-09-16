FactoryBot.define do
  factory :order do
    quantity { Faker::Number.between(from: 0, to: 100) }
    total { purchase.price * quantity }
    paid { false }
    delivery_city { 'Sinop' }
    user { association :user }
    purchase { association :purchase }
  end
end
