require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
  it 'automatically capitalize names' do
    subject.name = 'fulano do da dos das e silva neto'
    subject.save
    expect(subject.name).to eq('Fulano do da dos das e Silva Neto')
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('email@test.com').for(:email) }
  it { is_expected.to_not allow_value('emailtest.com', 'email@testcom', 'emailtestcom').for(:email) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(50) }
  it { is_expected.to validate_confirmation_of(:password) }

  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_length_of(:address).is_at_least(2).is_at_most(75) }
  it { is_expected.to allow_values('bla bla, 78', 'bla bla, s/n', 'bla bla, 98, ap 200').for(:address) }
  it { is_expected.to_not allow_values('bla bla bla bla', 'bla bla bla bla 78').for(:address) }

  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_length_of(:city).is_at_least(2).is_at_most(30) }

  it { is_expected.to validate_presence_of(:state) }
  it {
    is_expected.to validate_inclusion_of(:state).in_array(
      %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ
         RN RO RS RR SC SE SP TO]
    )
  }

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
  it { is_expected.to validate_inclusion_of(:account_type).in_array(['Consumidor', 'Voluntário', 'Ponto de Entrega']) }

  # it { is_expected.to validate_length_of(:instagram).is_at_least(2).is_at_most(75) }

  # it { is_expected.to validate_length_of(:facebook).is_at_least(2).is_at_most(75) }

  # it { is_expected.to validate_length_of(:lattes).is_at_least(2).is_at_most(75) }

  # it { is_expected.to validate_length_of(:institution).is_at_least(2).is_at_most(75) }

  # it { is_expected.to validate_length_of(:degree).is_at_least(2).is_at_most(75) }

  # it { is_expected.to validate_inclusion_of(:unemat_bond).in_array(['Professor', 'Aluno', 'Colaborador Externo']) }
  # context 'is a volunteer' do
  #   def save_volunteer
  #     subject.account_type = 'Voluntário'
  #     subject.save
  #   end
  #   it 'requires institution' do
  #     save_volunteer
  #     expect(subject.errors[:institution]).to eq('cannot be nil')
  #   end
  #   it 'requires degree' do
  #     save_volunteer
  #     expect(subject.errors[:degree]).to eq('cannot be nil')
  #   end
  #   it 'requires unemat_bond' do
  #     save_volunteer
  #     expect(subject.errors[:unemat_bond]).to eq('cannot be nil')
  #   end
  # end
end
