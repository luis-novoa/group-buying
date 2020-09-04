FactoryBot.define do
  factory :partner do
    name { "MyString" }
    description { "MyText" }
    website { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    city { "MyString" }
    state { "MyString" }
    supplier { false }
    partner_page { false }
  end
end
