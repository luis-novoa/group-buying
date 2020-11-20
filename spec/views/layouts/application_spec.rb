require 'rails_helper'

RSpec.describe 'Navbar', type: :feature do
  subject { page }

  before(:each) { visit root_path }
  context 'for any user' do
    it { is_expected.to have_link 'Início', href: root_path }
    it { is_expected.to have_link 'Sobre o Projeto', href: about_path }
    it { is_expected.to have_link 'Parceiros', href: partners_path }
  end

  context 'for not logged users' do
    it { is_expected.to have_link 'Acesse sua Conta', href: new_user_session_path }
    it { is_expected.to have_link 'Cadastre-se', href: new_user_registration_path }
  end

  context 'for logged users' do
    let(:user) { create(:user) }
    before(:each) { login(user) }
    it { is_expected.to have_link 'Carrinho', href: orders_path }
    it { is_expected.to have_link 'Minha Conta', href: user_path(user) }
    it { is_expected.to have_link 'Sair', href: destroy_user_session_path }
  end
end
