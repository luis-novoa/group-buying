require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order) }

  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer }

  it { is_expected.to validate_presence_of(:total) }
  it { is_expected.to validate_numericality_of(:total) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:purchase_id) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:purchase) }
end
