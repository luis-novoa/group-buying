require 'rails_helper'

RSpec.describe PurchaseProduct, type: :model do
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }

  it { is_expected.to validate_numericality_of(:quantity).only_integer }

  it { is_expected.to validate_presence_of(:offer_city) }
  it { is_expected.to validate_inclusion_of(:offer_city).in_array(%w[Sinop Cuiabá Ambas]) }
end
