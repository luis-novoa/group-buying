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

  context 'access from any account' do
    let(:user) { create(:user) }
    let(:user1) { create(:user, phone2: nil, phone2_type: nil) }
    before(:each) do
      login(user)
      click_on 'Minha Conta'
    end

    it { is_expected.to have_text user.name }
    it { is_expected.to have_text user.email }
    it { is_expected.to have_text user.address }
    it { is_expected.to have_text user.city }
    it { is_expected.to have_text user.state }
    it { is_expected.to have_text user.phone1 }
    it { is_expected.to have_text user.phone1_type }
    it { is_expected.to have_text user.phone2 }
    it { is_expected.to have_text user.phone2_type }
    it { is_expected.to have_text user.account_type }
    it { is_expected.to have_link href: edit_user_registration_path }
    it "doesn't show phone2 field if user didn't provide it" do
      click_on 'Sair'
      login(user1)
      click_on 'Minha Conta'
      is_expected.to_not have_text 'Telefone 2'
    end
  end

  context 'access with buyer account' do
    let(:buyer) { create(:user) }
    before(:each) do
      login(buyer)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(buyer)) }
    it { is_expected.to have_css('.buyer-greeting') }
    it { is_expected.to_not have_link href: users_path }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(volunteer)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(volunteer)) }
    it { is_expected.to have_css('.volunteer-greeting') }
    it { is_expected.to have_link href: users_path }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:delivery) }
    before(:each) do
      login(delivery)
      click_on 'Minha Conta'
    end
    it { is_expected.to have_current_path(user_path(delivery)) }
    it { is_expected.to have_css('.delivery-point-greeting') }
    it { is_expected.to have_link href: users_path }
  end
end
