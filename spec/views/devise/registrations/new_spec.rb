require 'rails_helper'

RSpec.describe 'UserRegistrations#new', type: :feature do
  subject { page }

  context 'structure' do
    before(:each) { visit new_user_registration_path }
    it { is_expected.to have_field 'Email*' }
    it { is_expected.to have_field 'Senha*' }
    it { is_expected.to have_field 'Digite a senha novamente*' }
    it { is_expected.to have_field 'Nome Completo*' }
    it { is_expected.to have_field 'DDD*' }
    it { is_expected.to have_field 'Telefone*' }
    it {
      is_expected.to have_select 'Tipo de Telefone*',
                                 with_options: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
    }
    it { is_expected.to have_field 'Telefone Adicional' }
    it {
      is_expected.to have_select 'Tipo de Telefone',
                                 with_options: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
    }
    it { is_expected.to have_select 'Tipo de Conta*', with_options: ['Comprador', 'Voluntário', 'Ponto de Entrega'] }
    it { is_expected.to have_field 'CPF*' }
  end

  context 'successful sign up' do
    let(:user) { build(:user) }
    let(:password) { Faker::Lorem.characters(number: 6) }
    before(:each) do
      visit new_user_registration_path
      fill_in 'Email*',	with: user.email
      fill_in 'Senha*', with: user.password
      fill_in 'Digite a senha novamente*', with: user.password
      fill_in 'Nome Completo*', with: user.name
      fill_in 'DDD*', with: user.ddd1
      fill_in 'Telefone*', with: user.phone1
      select user.phone1_type, from: :user_phone1_type
      fill_in 'CPF*', with: user.cpf
    end

    context 'as buyer' do
      before(:each) { select 'Comprador', from: 'Tipo de Conta*' }
      it 'with everything filled up' do
        fill_in 'DDD', with: user.ddd2
        fill_in 'Telefone Adicional', with: user.phone2
        select user.phone2_type, from: :user_phone2_type
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
    end

    context 'as delivery point' do
      before(:each) do
        select 'Ponto de Entrega', from: 'Tipo de Conta*'
        click_on 'Enviar'
      end
      it 'need admin approval' do
        expect(User.all.first.waiting_approval).to eq(true)
      end
    end
  end
end
