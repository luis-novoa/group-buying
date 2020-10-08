RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
  # config.profile_examples = 10
end

def phone_creator
  ddd = Faker::Number.between(from: 11, to: 99)
  first_half = Faker::Number.between(from: 9_000, to: 99_999)
  second_half = Faker::Number.number(digits: 4)
  "(#{ddd}) #{first_half}-#{second_half}"
end

def phone_type_creator
  types = ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
  types[Faker::Number.between(from: 0, to: 2)]
end

def account_type_creator
  types = ['Comprador', 'Voluntário', 'Ponto de Entrega']
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

def generate_cpf
  "#{Faker::Number.number(digits: 3)}.#{Faker::Number.number(digits: 3)}." \
    "#{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 2)}"
end

def brazilian_currency(number)
  format('%<price>.2f', price: number).gsub(/\./, ',')
end

def login(user)
  user.confirm
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Senha', with: user.password
  click_on 'Log in'
end
