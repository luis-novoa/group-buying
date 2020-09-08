FactoryBot.define do
  factory :order do
    purchase { create(:purchase) }
    quantity { Faker::Number.between(from: 0, to: 100) }
    total { purchase.price * quantity }
    # total { association(:purchase).price * quantity }
    paid { false }
    user_id { create(:user).id }
    purchase_id { purchase.id }
    # user { association :user }
    # purchase { association :purchase }
  end
end
