require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(75) }
  it 'automatically capitalize names' do
    subject.name = 'fulano do da dos das e silva neto'
    subject.save
    expect(subject.name).to eq('Fulano do da dos das e Silva Neto')
  end

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_length_of(:description).is_at_least(2).is_at_most(500) }

  it { is_expected.to validate_presence_of(:partner_id) }
end
