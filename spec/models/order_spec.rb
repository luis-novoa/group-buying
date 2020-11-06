require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build(:order, purchase_product: create(:purchase_product)) }

  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0).only_integer }

  it('calculates total') do
    subject.purchase_product = create(:purchase_product)
    subject.save
    expect(subject.total).to eq(subject.quantity * subject.purchase_product.price)
  end

  it { is_expected.to validate_presence_of(:delivery_city) }
  it { is_expected.to validate_inclusion_of(:delivery_city).in_array(%w[Sinop Cuiabá]) }

  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:status).in_array(%w[Carrinho Processando Pago Entregue]) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:purchase_product).required }
  it { is_expected.to belong_to(:payment).optional }

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

  context "update status to 'pago'" do
    let(:purchase) { create(:purchase, total: 0) }
    let(:purchase_product) { create(:purchase_product, purchase: purchase) }
    let(:order) { create(:order, purchase_product: purchase_product) }

    it 'adds value to the purchase' do
      order.update(status: 'Pago')
      expect(purchase.reload.total).to eq(order.total)
    end
  end
end
