require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order) }

  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer }

  it { is_expected.to validate_presence_of(:total) }
  it { is_expected.to validate_numericality_of(:total) }

  it { is_expected.to validate_presence_of(:delivery_city) }
  it { is_expected.to validate_inclusion_of(:delivery_city).in_array(%w[Sinop Cuiabá]) }

  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:status).in_array(%w[Carrinho Processando Pago Entregue]) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:purchase_product).required }

  context '.delivery_city != order.purchase_product.offer_city' do
    let(:purchase_product) { create(:purchase_product) }
    before(:each) do
      subject.delivery_city = 'Sinop'
      subject.purchase_product = purchase_product
    end
    it "doesn't save if cities are different" do
      purchase_product.update(offer_city: 'Cuiabá')
      expect(subject.save).to eq(false)
    end

    it 'saves if both cities are included' do
      purchase_product.update(offer_city: 'Sinop e Cuiabá')
      expect(subject.save).to eq(true)
    end
  end
end
