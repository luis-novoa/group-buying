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
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    before(:each) do
      login(user1)
      visit user_path(user2)
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end
end
