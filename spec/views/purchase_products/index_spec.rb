require 'rails_helper'

RSpec.describe 'Purchase_products#index', type: :feature do
  subject { page }

  let!(:purchase_products) { create_list(:purchase_product, 2) }
  let!(:inactive_purchase_product) { create(:inactive_purchase_product) }

  before(:each) { visit root_path }

  it { is_expected.to have_link href: purchase_product_path(purchase_products[0]) }
  it { is_expected.to have_link href: purchase_product_path(purchase_products[1]) }
  it { is_expected.to_not have_link href: purchase_product_path(inactive_purchase_product) }
  it { is_expected.to have_text purchase_products[0].name }
  it { is_expected.to have_text purchase_products[1].name }
  it { is_expected.to_not have_text inactive_purchase_product.name }
  it { is_expected.to have_text format('%<price>.2f', price: purchase_products[0].price) }
  it { is_expected.to have_text format('%<price>.2f', price: purchase_products[1].price) }
  it { is_expected.to_not have_text format('%<price>.2f', price: inactive_purchase_product.price) }
end
