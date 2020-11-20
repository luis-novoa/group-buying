require 'rails_helper'

RSpec.describe 'Purchases#edit', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  let(:purchase) { create(:purchase) }
  context 'attempt to access from unlogged user' do
    before(:each) { visit edit_purchase_path(purchase) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit edit_purchase_path(purchase)
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
      visit edit_purchase_path(purchase)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit edit_purchase_path(purchase)
    end
    it { is_expected.to have_current_path(edit_purchase_path(purchase)) }

    context 'form' do
      let(:purchase_product) { create(:purchase_product, purchase: purchase) }
      let(:purchase_product2) { create(:purchase_product, purchase: purchase) }
      let(:order) { create(:order, purchase_product: purchase_product, status: 'Pago') }
      let(:order2) { create(:order, purchase_product: purchase_product2, status: 'Pago') }
      # it 'deletes inactive instance with zero total' do
      #   purchase.update(total: 0)
      #   choose 'Inativa'
      #   click_on 'Enviar'
      #   expect(Purchase.all.count).to eq(0)
      # end

      it 'turns instance inactive' do
        purchase.update(total: 10)
        choose 'Inativa'
        click_on 'Enviar'
        expect(purchase.reload.active).to eq(false)
      end

      # it 'changes orders in right conditions' do
      #   choose 'Inativa'
      #   select 'Pronto para Retirada'
      #   click_on 'Enviar'
      #   expect(Order.all.all? { |order| order.status == 'Pronto para Entrega' }).to eq(true)
      # end
    end
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit edit_purchase_path(purchase)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end
end
