require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(number: 6) }
    password_confirmation { password }
    address { brazilian_address }
    city { Faker::Address.city }
    state { state_creator }
    phone1 { phone_creator }
    phone1_type { phone_type_creator }
    account_type { account_type_creator }
  end
end

def phone_creator
  ddd = Faker::Number.between(from: 11, to: 99)
  first_half = Faker::Number.between(from: 90_000, to: 99_999)
  second_half = Faker::Number.number(digits: 4)
  "+55 (#{ddd}) #{first_half}-#{second_half}"
end

def phone_type_creator
  types = ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
  types[Faker::Number.between(from: 0, to: 2)]
end

def account_type_creator
  types = ['Consumidor', 'Voluntário', 'Ponto de Entrega']
  types[Faker::Number.between(from: 0, to: 2)]
end

def brazilian_address
  "#{Faker::Address.street_name}, #{Faker::Number.between(from: 1, to: 10_000)}, #{Faker::Address.secondary_address}"
end

def state_creator
  types = %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ
             RN RO RS RR SC SE SP TO]
  types[Faker::Number.between(from: 0, to: 26)]
end
