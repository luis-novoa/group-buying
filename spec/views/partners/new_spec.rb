require 'rails_helper'

RSpec.describe 'Partners#new', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  context 'attempt to access from unlogged user' do
    before(:each) { visit new_partner_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_delivery) { create(:delivery) }
    before(:each) do
      login(pending_delivery)
      visit new_partner_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') {
      is_expected.to have_text(
        'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa para que você possa acessar esta página.'
      )
    }
  end

  context 'access with buyer account' do
    let(:buyer) { create(:user) }
    before(:each) do
      login(buyer)
      visit new_partner_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit new_partner_path
    end
    it { is_expected.to have_current_path(new_partner_path) }
  end

  context 'access with delivery point account without related partner' do
    let(:delivery) { create(:delivery) }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit new_partner_path
    end
    it { is_expected.to have_current_path(new_partner_path) }
  end

  context 'access with delivery point account with related partner already' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit new_partner_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'form' do
    let(:partner) { build(:partner) }

    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit new_partner_path
      fill_in 'Nome Fantasia*',	with: partner.name
      fill_in 'Razão Social*',	with: partner.official_name
      fill_in 'CNPJ*',	with: partner.cnpj
      fill_in 'Endereço*',	with: partner.address
      fill_in 'Cidade*',	with: partner.city
      select partner.state, from: 'Estado*'
      fill_in 'Descrição*',	with: partner.description
      fill_in 'Website',	with: partner.website
      fill_in 'Email*',	with: partner.email
      fill_in 'DDD*', with: partner.ddd1
      fill_in 'Telefone*',	with: partner.phone1
      select partner.phone1_type, from: :partner_phone1_type
      fill_in 'DDD', with: partner.ddd2
      fill_in 'Telefone Adicional',	with: partner.phone2
      select partner.phone2_type, from: :partner_phone2_type
      choose 'Fornecedor'
      click_on 'Enviar'
    end
    it('creates new instance of partner') { expect(Partner.count).to eq(1) }
    it('creates supplier') { expect(Partner.first.supplier).to eq(true) }
  end
end
