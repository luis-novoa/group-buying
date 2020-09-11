require 'rails_helper'

RSpec.describe Purchase, type: :model do
  subject { build(:purchase) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer }
  it {
    is_expected.to validate_inclusion_of(:status).in_array(
      ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada']
    )
  }
  it { is_expected.to validate_numericality_of(:total) }
  it { is_expected.to validate_length_of(:message).is_at_most(500).allow_nil }

  it { is_expected.to belong_to(:product).required }
end