require 'rails_helper'

RSpec.describe 'Orders#index', type: :feature do
  subject { page }

  context 'attempt to access from unlogged user' do
    before(:each) { visit orders_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'access from logged user' do
    let(:user) { create(:user, cpf: 43_351_752_210, email: 'something@sandbox.pagseguro.com.br') }
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
    it { is_expected.to have_selector "input[value='#{order.quantity}']" }
    it { is_expected.to have_text brazilian_currency(order.total) }
    it { is_expected.to have_select 'order_delivery_city', selected: order.delivery_city }
    it { is_expected.to have_button 'Modificar' }
    it 'updates order' do
      fill_in 'order_quantity',	with: '10'
      click_on 'Modificar'
      expect(order.reload.quantity).to eq(10)
    end
    it 'deletes order' do
      click_on 'Retirar do Carrinho'
      check_order = Order.where(id: order.id)
      expect(check_order.empty?).to eq(true)
    end
    it { is_expected.to have_no_text paid_order.purchase_product.name }
    it { is_expected.to have_no_text processing_order.purchase_product.name }
    it { is_expected.to have_no_text delivered_order.purchase_product.name }
    # context 'closing the shopping cart', js: true do
    #   before(:each) { click_on 'Fechar Carrinho' }
    #   it('change order status') { expect(order.reload.status).to eq('Processando') }
    #   it('adds payment_code to the order') { expect(order.reload.payment_code).to_not eq(nil) }
    #   it 'redirects to the payment website' do
    #     expect(current_path).to eq(
    #       '/checkout/nc/sender-data-payment-methods.jhtml'
    #     )
    #   end
    # end
  end
end
