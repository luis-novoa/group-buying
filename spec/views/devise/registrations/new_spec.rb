require 'rails_helper'

RSpec.describe 'UserRegistration#new', type: :feature do
  subject { page }

  before(:each) { visit new_user_registration_path }

  it { is_expected.to have_field 'Email*' }
  it { is_expected.to have_field 'Senha*' }
  it { is_expected.to have_field 'Digite a senha novamente*' }
  it { is_expected.to have_field 'Nome Completo*' }
  it { is_expected.to have_field 'Endereço*' }
  it { is_expected.to have_field 'Número*' }
  it { is_expected.to have_field 'Complemento' }
  it { is_expected.to have_field 'Cidade*' }
  it {
    is_expected.to have_select 'Estado*', with_options:
    %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RO RS RR SC SE SP TO]
  }
  it { is_expected.to have_field :ddd1 }
  it { is_expected.to have_field :phone1_first_half }
  it { is_expected.to have_field :phone1_second_half }
  it { is_expected.to have_select 'Tipo de Telefone*', with_options: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp'] }
  it { is_expected.to have_field :ddd2 }
  it { is_expected.to have_field :phone2_first_half }
  it { is_expected.to have_field :phone2_second_half }
  it { is_expected.to have_select 'Tipo de Telefone', with_options: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp'] }
  it { is_expected.to have_select 'Tipo de Conta', with_options: ['Comprador', 'Voluntário', 'Ponto de Entrega'] }
end
