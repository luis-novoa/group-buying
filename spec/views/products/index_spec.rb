require 'rails_helper'

RSpec.describe 'Products#index', type: :feature do
  subject { page }

  let(:volunteer) { create(:volunteer_info).user }
  context 'attempt to access from unlogged user' do
    before(:each) { visit products_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    let(:pending_volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(pending_volunteer)
      visit products_path
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
      visit products_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with volunteer account' do
    let!(:products) { create_list(:product, 2) }
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit products_path
    end
    it { is_expected.to have_current_path(products_path) }
    it { is_expected.to have_link products[0].name, href: product_path(products[0])  }
    it { is_expected.to have_link products[1].name, href: product_path(products[1])  }
    it { is_expected.to have_link products[0].partner.name, href: partner_path(products[0].partner)  }
    it { is_expected.to have_link products[1].partner.name, href: partner_path(products[1].partner)  }
    it { is_expected.to have_link href: edit_product_path(products[0]) }
    it { is_expected.to have_link href: edit_product_path(products[1]) }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:partner_user).user }
    before(:each) do
      delivery.update(waiting_approval: false)
      login(delivery)
      visit products_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end
end
