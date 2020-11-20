require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(75) }
  it 'automatically capitalize names' do
    subject.partner.save
    subject.partner_id = subject.partner.id
    subject.name = 'fulano do da dos das e silva neto'
    subject.save
    expect(subject.name).to eq('Fulano do da dos das e Silva Neto')
  end

  it { is_expected.to validate_presence_of(:weight) }
  it { is_expected.to validate_numericality_of(:weight).is_greater_than(0).only_integer }

  it { is_expected.to validate_presence_of(:weight_type) }
  it { is_expected.to validate_inclusion_of(:weight_type).in_array(%w[g mL]) }

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_least(2).is_at_most(5000) }

  it { is_expected.to have_many(:purchase_products) }
  it { is_expected.to belong_to(:partner).conditions(supplier: true).required }
end
