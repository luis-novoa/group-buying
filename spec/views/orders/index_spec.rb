require 'rails_helper'

RSpec.describe 'Orders#index', type: :feature do
  subject { page }

  context 'attempt to access from unlogged user' do
    before(:each) { visit orders_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'access from logged user' do
    let(:user) { create(:user) }
    let!(:order) { create(:order, user: user) }
    let!(:paid_order) { create(:order, user: user, status: 'Pago') }
    let!(:processing_order) { create(:order, user: user, status: 'Processando') }
    let!(:delivered_order) { create(:order, user: user, status: 'Entregue') }
    before(:each) do
      login(user)
      click_on 'Carrinho'
    end
    it { is_expected.to have_text order.purchase_product.name }
    it { is_expected.to have_text brazilian_currency(order.purchase_product.price) }
    it { is_expected.to have_text order.quantity }
    it { is_expected.to have_text brazilian_currency(order.total) }
    it { is_expected.to have_text order.delivery_city }
    it 'deletes order' do
      click_on 'Retirar do Carrinho'
      check_order = Order.where(id: order.id)
      expect(check_order.empty?).to eq(true)
    end
    it { is_expected.to have_no_text paid_order.purchase_product.name }
    it { is_expected.to have_no_text processing_order.purchase_product.name }
    it { is_expected.to have_no_text delivered_order.purchase_product.name }
  end
end
