require 'rails_helper'

RSpec.describe PurchaseProduct, type: :model do
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }

  it { is_expected.to validate_numericality_of(:quantity).only_integer }

  it { is_expected.to validate_presence_of(:offer_city) }
  it { is_expected.to validate_inclusion_of(:offer_city).in_array(['Sinop', 'Cuiabá', 'Sinop e Cuiabá']) }

  it { is_expected.to have_many(:orders) }
  it { is_expected.to belong_to(:purchase) }
  it { is_expected.to belong_to(:product) }
end
