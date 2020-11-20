require 'rails_helper'

RSpec.describe 'PurchaseProducts#new', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  let(:purchase) { create(:purchase) }
  context 'attempt to access from unlogged user' do
    before(:each) { visit new_purchase_product_path(purchase_id: purchase.id) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit new_purchase_product_path(purchase_id: purchase.id)
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
      visit new_purchase_product_path(purchase_id: purchase.id)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    let!(:product) { create(:product, partner: purchase.partner) }
    let!(:purchase_product) { create(:purchase_product, purchase: purchase) }
    before(:each) do
      purchase_product.product.update(partner: product.partner)
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit new_purchase_product_path(purchase_id: purchase.id)
    end
    it { is_expected.to have_current_path(new_purchase_product_path(purchase_id: purchase.id)) }
    it { is_expected.to have_no_text purchase_product.name }
    context 'product form' do
      before(:each) do
        select product.name + ' ' + format_weight(product.weight, product.weight_type), from: 'Produto*'
        fill_in 'Preço*',	with: '10'
        fill_in 'Quantidade',	with: '10000'
        select 'Sinop', from: 'Disponível em*'
        click_on 'Oferecer Produto'
      end
      it('creates a new purchase_product') { expect(purchase.purchase_products.count).to eq(2) }
    end
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit new_purchase_product_path(purchase_id: purchase.id)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end
end
