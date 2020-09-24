require 'rails_helper'

RSpec.describe 'Partners#edit', type: :feature do
  subject { page }
  let(:partner) { create(:partner) }

  let(:volunteer) { create(:volunteer_info).user }
  context 'attempt to access from unlogged user' do
    before(:each) { visit edit_partner_path(partner) }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_delivery) { create(:delivery) }
    before(:each) do
      login(pending_delivery)
      visit edit_partner_path(partner)
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
      visit edit_partner_path(partner)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:delivery) }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit edit_partner_path(partner)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit edit_partner_path(partner)
    end
    it { is_expected.to have_current_path(edit_partner_path(partner)) }
  end
end
