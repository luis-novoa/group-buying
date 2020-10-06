require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
  it 'automatically capitalize names' do
    subject.name = 'fulano do da dos das e silva neto'
    subject.save
    p subject.errors unless subject.errors.empty?
    expect(subject.name).to eq('Fulano do da dos das e Silva Neto')
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('email@test.com').for(:email) }
  it { is_expected.to_not allow_value('emailtest.com', 'email@testcom', 'emailtestcom').for(:email) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(50) }
  it { is_expected.to validate_confirmation_of(:password) }

  it { is_expected.to validate_presence_of(:phone1) }
  it { is_expected.to validate_length_of(:phone1).is_at_least(14).is_at_most(15) }
  it { is_expected.to allow_values('(66) 8536-7485', '(66) 98536-7485').for(:phone1) }
  it { is_expected.to_not allow_value('a' * 14).for(:phone1) }

  it { is_expected.to validate_presence_of(:phone1_type) }
  it {
    is_expected.to validate_inclusion_of(:phone1_type).in_array(
      ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
    )
  }

  context '.phone2 defined' do
    it { is_expected.to validate_length_of(:phone2).is_at_least(14).is_at_most(15) }
    it { is_expected.to allow_values('(66) 8536-7485', '(66) 98536-7485').for(:phone2) }
    it { is_expected.to_not allow_values('a' * 14).for(:phone2) }
    it { is_expected.to_not allow_value(nil).for(:phone2_type) }
  end
  context '.phone2 undefined' do
    before(:each) { subject.phone2 = nil }
    it { is_expected.to validate_absence_of(:phone2_type) }
  end
  context '.phone2_type defined' do
    it { is_expected.to_not allow_value(nil).for(:phone2) }
    it {
      is_expected.to validate_inclusion_of(:phone2_type).in_array(
        ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp']
      )
    }
  end
  context 'phone2_type undefined' do
    before(:each) { subject.phone2_type = nil }
    it { is_expected.to allow_value(nil).for(:phone2) }
  end
  it { is_expected.to validate_presence_of(:account_type) }
  it { is_expected.to validate_inclusion_of(:account_type).in_array(['Comprador', 'Voluntário', 'Ponto de Entrega']) }
  it { is_expected.to validate_presence_of(:cpf) }
  it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
  it { is_expected.to validate_length_of(:cpf).is_at_least(13).is_at_most(19) }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_one(:partner) }
  it { is_expected.to have_one(:volunteer_info).dependent(:destroy) }
end
