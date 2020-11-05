require 'rails_helper'

RSpec.describe 'PurchaseLists#index', type: :feature do
  subject { page }

  let!(:order_ready_to_deliver) { create(:order, status: 'Pago') }
  let!(:order_ready_to_deliver2) { create(:order, status: 'Pago') }
  let!(:common_order) { create(:order) }
  let!(:user1) { order_ready_to_deliver.user }
  let!(:user2) { order_ready_to_deliver2.user }
  let!(:user3) { common_order.user }
  let!(:purchase_ready1) { order_ready_to_deliver.purchase_product.purchase }
  let!(:purchase_ready2) { order_ready_to_deliver2.purchase_product.purchase }
  context 'attempt to access from unlogged user' do
    before(:each) { visit purchase_lists_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit purchase_lists_path
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
      visit purchase_lists_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account', js: true do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      purchase_ready1.update(status: 'Pronto para Retirada')
      purchase_ready2.update(status: 'Pronto para Retirada')
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit purchase_lists_path
      sleep(9999)
    end
    it { is_expected.to have_current_path(purchase_lists_path) }
    it { is_expected.to have_link user1.name, href: purchase_list_path(user1) }
    it { is_expected.to have_link user2.name, href: purchase_list_path(user2) }
    it { is_expected.to have_no_link user3.name, href: purchase_list_path(user3) }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit purchase_lists_path
    end
    it { is_expected.to have_current_path(purchase_lists_path) }
  end
end
