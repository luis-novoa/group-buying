require 'rails_helper'

RSpec.describe 'PurchaseLists#show', type: :feature do
  subject { page }

  let(:user) { create(:user) }
  let!(:order_ready_to_deliver) { create(:order, user: user, status: 'Pago') }
  let!(:order_ready_to_deliver2) { create(:order, user: user, status: 'Pago') }
  let!(:common_order) { create(:order, user: user) }
  let!(:purchase_ready1) { order_ready_to_deliver.purchase_product.purchase }
  let!(:purchase_ready2) { order_ready_to_deliver2.purchase_product.purchase }
  context 'attempt to access from unlogged user' do
    before(:each) { visit purchase_list_path(user) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit purchase_list_path(user)
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
      visit purchase_list_path(user)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      purchase_ready1.update(status: 'Pronto para Retirada')
      purchase_ready2.update(status: 'Pronto para Retirada')
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit purchase_list_path(user)
    end
    it { is_expected.to have_current_path(purchase_list_path(user)) }
    it { is_expected.to have_text user.name }
    it { is_expected.to have_text order_ready_to_deliver.purchase_product.name }
    it { is_expected.to have_text order_ready_to_deliver.quantity }
    it { is_expected.to have_text order_ready_to_deliver2.purchase_product.name }
    it { is_expected.to have_no_text common_order.purchase_product.name }
    it 'can report delivery' do
      click_on 'Confirmar Entrega'
      is_expected.to have_no_link user.name, href: purchase_list_path(user)
    end
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      purchase_ready1.update(status: 'Pronto para Retirada')
      delivery.update(waiting_approval: false)
      login(delivery)
      visit purchase_list_path(user)
    end
    it { is_expected.to have_current_path(purchase_list_path(user)) }
  end
end
