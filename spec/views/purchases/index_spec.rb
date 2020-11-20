require 'rails_helper'

RSpec.describe 'Purchases#index', type: :feature do
  subject { page }

  let!(:purchases) { create_list(:purchase, 2) }
  context 'attempt to access from unlogged user' do
    before(:each) { visit purchases_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit purchases_path
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
      visit purchases_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit purchases_path
    end
    it { is_expected.to have_current_path(purchases_path) }
    it { is_expected.to have_link purchases[0].id, href: purchase_path(purchases[0]) }
    it { is_expected.to have_link purchases[1].id, href: purchase_path(purchases[1]) }
    it { is_expected.to have_text purchases[0].partner.name }
    it { is_expected.to have_text purchases[1].partner.name }
    it { is_expected.to have_text purchases[0].total }
    it { is_expected.to have_text purchases[1].total }
    it { is_expected.to have_text purchases[0].created_at.to_date }
    it { is_expected.to have_text purchases[1].created_at.to_date }
    it { is_expected.to have_link href: edit_purchase_path(purchases[0]) }
    it { is_expected.to have_link href: edit_purchase_path(purchases[1]) }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit purchases_path
    end
    it { is_expected.to have_current_path(purchases_path) }
    it { is_expected.to have_no_link href: edit_purchase_path(purchases[0]) }
    it { is_expected.to have_no_link href: edit_purchase_path(purchases[1]) }
  end
end
