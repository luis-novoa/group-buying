require 'rails_helper'

RSpec.describe 'Products#show', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  let(:product) { create(:product) }
  context 'attempt to access from unlogged user' do
    before(:each) { visit product_path(product) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit product_path(product)
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
      visit product_path(product)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit product_path(product)
    end
    it { is_expected.to have_current_path(product_path(product)) }
    it { is_expected.to have_link href: products_path }
    it { is_expected.to have_link href: edit_product_path(product) }
    it { is_expected.to have_link product.partner.name, href: partner_path(product.partner) }
    it { is_expected.to have_text product.name }
    it { is_expected.to have_text product.weigth }
    it { is_expected.to have_text product.description }
    it 'has the possibility to delete the product' do
      click_on 'Apagar este Produto'
      expect(Product.all.count).to eq(0)
    end
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit product_path(product)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end
end
