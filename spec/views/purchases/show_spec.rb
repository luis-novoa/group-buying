require 'rails_helper'

RSpec.describe 'Purchases#show', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  let(:purchase) { create(:purchase) }
  context 'attempt to access from unlogged user' do
    before(:each) { visit purchase_path(purchase) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit purchase_path(purchase)
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
      visit purchase_path(purchase)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with delivery point account' do
    let!(:purchase_product) { create(:purchase_product, purchase: purchase) }
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit purchase_path(purchase)
    end
    it { is_expected.to have_current_path(purchase_path(purchase)) }
    it { is_expected.to have_no_link href: edit_purchase_path(purchase) }
    it { is_expected.to have_text purchase_product.name }
    it { is_expected.to have_text purchase_product.price }
    it { is_expected.to have_text purchase_product.quantity }
    it { is_expected.to have_text purchase_product.offer_city }
    it { is_expected.to have_no_link purchase_product_path(purchase_product) }
  end

  context 'access with volunteer account' do
    let!(:purchase_product) { create(:purchase_product, purchase: purchase) }
    let(:order) { build(:order, purchase_product: purchase_product) }
    before(:each) do
      volunteer.update(waiting_approval: false)
      purchase.update(updated_at: Time.current.change(month: 10))
      login(volunteer)
      visit purchase_path(purchase)
    end
    it { is_expected.to have_current_path(purchase_path(purchase)) }
    it { is_expected.to have_link href: edit_purchase_path(purchase) }
    it { is_expected.to have_link href: purchases_path }
    it { is_expected.to have_link href: partner_path(purchase.partner) }
    it { is_expected.to have_text purchase.status }
    it { is_expected.to have_text purchase.id }
    it { is_expected.to have_text purchase.total }
    it { is_expected.to have_text purchase.partner.name }
    it { is_expected.to have_text purchase.created_at.to_date }
    it { is_expected.to have_text purchase.updated_at.to_date }
    it 'can delete purchase product without orders' do
      click_on 'Apagar Oferta'
      expect(PurchaseProduct.count).to eq(0)
    end
    it "purchase product with orders doesn't display delete link" do
      order.save
      visit purchase_path(purchase)
      is_expected.to have_no_link 'Apagar Oferta'
    end
  end
end
