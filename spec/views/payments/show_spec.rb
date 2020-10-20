require 'rails_helper'

RSpec.describe 'Payments#show', type: :feature do
  subject { page }
  let(:payment) { create(:payment) }
  let(:user) { payment.user }

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
end
