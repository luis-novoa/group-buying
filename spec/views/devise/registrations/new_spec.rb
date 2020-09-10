require 'rails_helper'

RSpec.describe 'UserRegistration#new', type: :feature do
  subject { page }

  context 'structure' do
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
    it { is_expected.to have_select 'Tipo de Conta*', with_options: ['Comprador', 'Voluntário', 'Ponto de Entrega'] }
  end

  # context 'additional fields for volunteer' do
  #   before(:each) do
  #     visit new_user_registration_path
  #     select 'Voluntário', from: 'Tipo de Conta*'
  #   end

  #   it { is_expected.to have_field 'Instagram' }
  #   it { is_expected.to have_field 'Facebook' }
  #   it { is_expected.to have_field 'Lattes' }
  #   it { is_expected.to have_field 'Instituição*' }
  #   it { is_expected.to have_field 'Curso* (em andamento ou concluído)' }
  #   it { is_expected.to have_select 'Vínculo com a UNEMAT*', with_options: ['Professor', 'Aluno', 'Colaborador Externo'] }
  # end

  context 'successful sign up' do
    let(:password) { Faker::Lorem.characters(number: 6) }
    before(:each) do
      visit new_user_registration_path
      fill_in 'Email*',	with: Faker::Internet.email
      fill_in 'Senha*', with: password
      fill_in 'Digite a senha novamente*', with: password
      fill_in 'Nome Completo*', with: Faker::Name.name
      fill_in 'Endereço*', with: Faker::Address.street_name
      fill_in 'Número*', with: Faker::Number.between(from: 1, to: 10_000)
      fill_in 'Cidade*', with: Faker::Address.city
      select state_creator, from: 'Estado*'
      fill_in :ddd1, with: Faker::Number.between(from: 11, to: 99)
      fill_in :phone1_first_half, with: Faker::Number.between(from: 9_000, to: 99_999)
      fill_in :phone1_second_half, with: Faker::Number.number(digits: 4)
      select phone_type_creator, from: :user_phone1_type
    end

    context 'as buyer' do
      before(:each) { select 'Comprador', from: 'Tipo de Conta*' }
      it 'with everything filled up' do
        fill_in 'Complemento', with: Faker::Address.secondary_address
        fill_in :ddd2, with: Faker::Number.between(from: 11, to: 99)
        fill_in :phone2_first_half, with: Faker::Number.between(from: 9_000, to: 99_999)
        fill_in :phone2_second_half, with: Faker::Number.number(digits: 4)
        select phone_type_creator, from: :user_phone2_type
        click_on 'Enviar'
        expect(User.count).to eq(1)
      end

      it "doesn't need admin approval" do
        click_on 'Enviar'
        expect(User.all.first.waiting_approval).to eq(false)
      end

      it 'without optional information' do
        click_on 'Enviar'
        expect(User.count).to eq(1)
      end
    end

    context 'as volunteer' do
      before(:each) do
        select 'Voluntário', from: 'Tipo de Conta*'
        click_on 'Enviar'
      end
      it 'need admin approval' do
        expect(User.all.first.waiting_approval).to eq(true)
      end
      it { is_expected.to have_current_path(new_volunteer_info_path) }
    end
  end
end
