require 'rails_helper'

RSpec.describe 'Products#new', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  context 'attempt to access from unlogged user' do
    before(:each) { visit new_product_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit new_product_path
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
      visit new_product_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit new_product_path
    end
    it { is_expected.to have_current_path(new_product_path) }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit new_product_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'form' do
    let(:product) { build(:product) }
    let(:partner) { product.partner }

    it 'creates new instance of product associated to partner' do
      partner.save
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit new_product_path
      select partner.name, from: 'Fornecedor*'
      fill_in 'Nome*',	with: product.name
      fill_in 'Peso*',	with: product.weigth
      fill_in 'Descrição Completa*',	with: product.description
      click_on 'Enviar'
      expect(partner.products.count).to eq(1)
    end
  end
end
