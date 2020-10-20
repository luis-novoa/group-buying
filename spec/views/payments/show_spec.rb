require 'rails_helper'

RSpec.describe 'Payments#show', type: :feature do
  subject { page }
  let(:payment) { create(:payment) }
  let(:user) { payment.user }
  let!(:orders) { create_list(:order, 2, user: user, payment: payment) }

  context 'attempt to access from unlogged user' do
    before(:each) { visit payment_path(payment) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from another user' do
    let(:user2) { create(:user) }
    before(:each) do
      login(user2)
      visit payment_path(payment)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'content' do
    before(:each) do
      login(user)
      visit payment_path(payment)
    end
    it { is_expected.to have_text orders[0].purchase_product.name }
    it { is_expected.to have_text brazilian_currency(orders[0].purchase_product.price) }
    it { is_expected.to have_text orders[0].quantity }
    it { is_expected.to have_text brazilian_currency(orders[0].total) }

    it { is_expected.to have_text orders[1].purchase_product.name }
    it { is_expected.to have_text brazilian_currency(orders[1].purchase_product.price) }
    it { is_expected.to have_text orders[1].quantity }
    it { is_expected.to have_text brazilian_currency(orders[1].total) }

    it { is_expected.to have_text brazilian_currency(orders[0].total + orders[1].total) }
    it {
      is_expected.to have_link href:
      "https://sandbox.pagseguro.uol.com.br/v2/checkout/payment.html?code=#{payment.code}"
    }
  end
end
