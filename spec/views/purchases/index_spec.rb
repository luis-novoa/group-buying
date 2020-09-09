require 'rails_helper'

RSpec.describe 'Purchases#index', type: :feature do
  subject { page }

  let!(:purchases) { create_list(:purchase, 2) }
  let!(:inactive_purchase) { create(:purchase, active: false) }

  before(:each) { visit root_path }

  it { is_expected.to have_link href: purchase_path(purchases[0]) }
  it { is_expected.to have_link href: purchase_path(purchases[1]) }
  it { is_expected.to_not have_link href: purchase_path(inactive_purchase) }
  it { is_expected.to have_text purchases[0].product.name }
  it { is_expected.to have_text purchases[1].product.name }
  it { is_expected.to_not have_text inactive_purchase.product.name }
  it { is_expected.to have_text format('%<price>.2f', price: purchases[0].price) }
  it { is_expected.to have_text format('%<price>.2f', price: purchases[1].price) }
  it { is_expected.to_not have_text format('%<price>.2f', price: inactive_purchase.price) }

  context 'with user not logged' do
    it { is_expected.to have_link 'Fazer Login', href: new_user_session_path }
    it { is_expected.to have_link 'Registrar-se', href: new_user_registration_path }
  end
end
