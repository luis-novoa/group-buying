require 'rails_helper'

RSpec.describe 'Users#show', type: :feature do
  subject { page }

  context 'attempt to access from unlogged user' do
    let(:user) { create(:user) }
    before(:each) { visit user_path(user) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from another user' do
    let(:user2) { create(:user) }

    context 'buyer' do
      let(:user1) { create(:user) }
      before(:each) do
        login(user1)
        visit user_path(user2)
      end
      it('redirects user to root') { is_expected.to have_current_path(root_path) }
      it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
    end

    context 'volunteer' do
      let(:user1) { create(:volunteer_info).user }
      before(:each) do
        user1.update(waiting_approval: false)
        login(user1)
        visit user_path(user2)
      end
      it { is_expected.to have_current_path(user_path(user2)) }
      it { is_expected.to have_no_link href: new_partner_path }
      it { is_expected.to have_no_link href: new_product_path }
      it { is_expected.to have_no_link href: products_path }
    end

    context 'delivery point' do
      let(:user1) { create(:delivery) }
      before(:each) do
        user1.update(waiting_approval: false)
        login(user1)
        visit user_path(user2)
      end
      it { is_expected.to have_current_path(user_path(user2)) }
    end

    context 'pending user' do
      let(:user1) { create(:delivery) }
      before(:each) do
        login(user1)
        visit user_path(user2)
      end
      it('redirects user to root') { is_expected.to have_current_path(root_path) }
      it('displays warning') {
        is_expected.to have_text(
          'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa para que você possa acessar esta página.'
        )
      }
    end
  end

  context 'access from any account' do
    let(:user) { create(:user) }
    let(:user1) { create(:user, phone2: nil, phone2_type: nil) }
    let!(:payment) { create(:payment) }
    let!(:order) { create(:order, user: user) }
    let!(:paid_order) { create(:order, user: user, status: 'Pago') }
    let!(:processing_order) { create(:order, user: user, status: 'Processando') }
    let!(:delivered_order) { create(:order, user: user, status: 'Entregue') }
    before(:each) do
      login(user)
      click_on 'Minha Conta'
    end

    it { is_expected.to have_text user.name }
    it { is_expected.to have_text user.email }
    it { is_expected.to have_text phone_format(user.ddd1, user.phone1) }
    it { is_expected.to have_text user.phone1_type }
    it { is_expected.to have_text phone_format(user.ddd2, user.phone2) }
    it { is_expected.to have_text user.phone2_type }
    it { is_expected.to have_text user.account_type }
    it { is_expected.to have_text cpf_format(user.cpf) }
    it "doesn't show phone2 field if user didn't provide it" do
      click_on 'Sair'
      login(user1)
      click_on 'Minha Conta'
      is_expected.to have_no_text 'Telefone 2'
    end
    it { is_expected.to have_no_text order.purchase_product.name }
    it { is_expected.to have_text paid_order.purchase_product.name }
    it { is_expected.to have_text processing_order.purchase_product.name }
    it { is_expected.to have_text delivered_order.purchase_product.name }
    it { is_expected.to have_text brazilian_currency(delivered_order.purchase_product.price) }
    it { is_expected.to have_text delivered_order.quantity }
    it { is_expected.to have_text brazilian_currency(delivered_order.total) }
    it { is_expected.to have_text delivered_order.delivery_city }
    it { is_expected.to have_text delivered_order.created_at.strftime('%d/%m/%Y') }
    it { is_expected.to have_text delivered_order.status }
    it { is_expected.to have_link 'Ver Pedido e Link de Pagamento', href: payment_path(delivered_order.payment) }
  end

  context 'access with buyer account' do
    let(:buyer) { create(:user) }
    before(:each) do
      login(buyer)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(buyer)) }
    it { is_expected.to have_no_link href: users_path }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    let!(:partner) { create(:partner) }
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(volunteer)) }
    it { is_expected.to have_link href: users_path }
    it { is_expected.to have_link href: new_partner_path }
    it { is_expected.to have_link href: partners_path }
    it { is_expected.to have_link href: new_product_path }
    it { is_expected.to have_link href: products_path }
    it { is_expected.to have_link href: purchases_path }
    it { is_expected.to have_link href: purchase_lists_path }
    it 'can open a collective purchase from the volunteer panel' do
      select partner.name, from: 'purchase_partner_id'
      click_on 'Criar Compra Coletiva com este Fornecedor'
      expect(Purchase.all.first.partner).to eq(partner)
    end
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:delivery) }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(delivery)) }
    it { is_expected.to have_link href: users_path }
    it { is_expected.to have_link href: purchase_lists_path }
  end

  context 'access with administrator account' do
    let(:administrator) { create(:adm_info).user }
    before(:each) do
      administrator.update(waiting_approval: false)
      login(administrator)
    end

    context "to a buyer's account" do
      let(:buyer) { create(:user) }
      it do
        visit user_path(buyer)
        is_expected.to have_link 'Tornar Voluntário', href: "/users/#{buyer.id}?account_type=Volunt%C3%A1rio"
      end
    end

    context "to a delivery point's account" do
      let(:delivery) { create(:delivery) }
      before(:each) do
        delivery.update(waiting_approval: false)
        visit user_path(delivery)
      end
      it { is_expected.to have_link 'Tornar Comprador', href: "/users/#{delivery.id}?account_type=Comprador" }
      it {
        is_expected.to have_link 'Tornar Voluntário',
                                 href: "/users/#{delivery.id}?account_type=Volunt%C3%A1rio"
      }
    end

    context 'to moderator account' do
      let(:moderator) { create(:mod_info).user }
      before(:each) do
        moderator.update(waiting_approval: false)
        visit user_path(moderator)
      end
      it { is_expected.to have_link 'Revogar Moderador', href: "/users/#{moderator.id}?moderator=false" }
    end

    context 'to volunteer account' do
      let(:volunteer) { create(:volunteer_info).user }
      before(:each) do
        volunteer.update(waiting_approval: false)
        visit user_path(volunteer)
      end
      it { is_expected.to have_link 'Tornar Moderador', href: "/users/#{volunteer.id}?moderator=true" }
      it { is_expected.to have_link 'Tornar Comprador', href: "/users/#{volunteer.id}?account_type=Comprador" }
    end
  end
end
