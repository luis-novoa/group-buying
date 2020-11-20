require 'rails_helper'

RSpec.describe 'Purchase_products#index', type: :feature do
  subject { page }

  let!(:purchase_products) { create_list(:purchase_product, 2) }
  let!(:inactive_purchase_product) { create(:inactive_purchase_product) }

  context 'user not logged' do
    before(:each) { visit root_path }

    it { is_expected.to have_link href: purchase_product_path(purchase_products[0]) }
    it { is_expected.to have_link href: purchase_product_path(purchase_products[1]) }
    it { is_expected.to have_no_link href: purchase_product_path(inactive_purchase_product) }
    it { is_expected.to have_text purchase_products[0].name }
    it { is_expected.to have_text purchase_products[1].name }
    it { is_expected.to have_no_text inactive_purchase_product.name }
    it { is_expected.to have_text brazilian_currency(purchase_products[0].price) }
    it { is_expected.to have_text brazilian_currency(purchase_products[1].price) }
    it { is_expected.to have_no_text brazilian_currency(inactive_purchase_product.price) }
    it { is_expected.to have_text 'Faça Login para Comprar', count: 2 }
  end

  context 'logged user' do
    let(:user) { create(:user) }
    let!(:order) { create(:order, user: user, purchase_product: purchase_products[1]) }
    let!(:paid_order) { create(:order, user: user, status: 'Pago') }
    let!(:processing_order) { create(:order, user: user, status: 'Processando') }

    before(:each) do
      purchase_products[0].update(offer_city: 'Sinop')
      login(user)
      visit root_path
    end

    it { is_expected.to have_button 'Adicionar ao Carrinho', count: 2 }
    it { is_expected.to have_button 'Modificar' }
    it { is_expected.to have_text 'Processando Pedido' }
    it { within("#product-#{purchase_products[0].id}") { is_expected.to have_no_text 'Cuiabá' } }
    it 'creates new order' do
      within("#product-#{purchase_products[0].id}") do
        fill_in 'Quantidade',	with: '10'
        click_on 'Adicionar ao Carrinho'
      end
      expect(user.orders.count).to eq(4)
    end
    it 'updates order' do
      within("#product-#{purchase_products[1].id}") do
        fill_in 'Quantidade',	with: '10'
        click_on 'Modificar'
      end
      expect(order.reload.quantity).to eq(10)
    end
  end
end
