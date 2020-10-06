require 'rails_helper'

RSpec.describe VolunteerInfo, type: :model do
  subject { build(:volunteer_info) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_length_of(:address).is_at_least(2).is_at_most(75) }
  it { is_expected.to allow_values('bla bla, 78', 'bla bla, s/n', 'bla bla, 98, ap 200').for(:address) }
  it { is_expected.to_not allow_values('bla bla bla bla', 'bla bla bla bla 78').for(:address) }

  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_length_of(:city).is_at_least(2).is_at_most(30) }

  it { is_expected.to validate_presence_of(:state) }
  it {
    is_expected.to validate_inclusion_of(:state).in_array(
      %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RO RS RR SC SE SP TO]
    )
  }
  
  it { is_expected.to validate_length_of(:instagram).is_at_least(2).is_at_most(75).allow_nil }

  it { is_expected.to validate_length_of(:facebook).is_at_least(2).is_at_most(75).allow_nil }

  it { is_expected.to validate_length_of(:lattes).is_at_least(2).is_at_most(75).allow_nil }

  it { is_expected.to validate_presence_of(:institution) }
  it { is_expected.to validate_length_of(:institution).is_at_least(2).is_at_most(75) }

  it { is_expected.to validate_presence_of(:degree) }
  it { is_expected.to validate_length_of(:degree).is_at_least(2).is_at_most(75) }

  it { is_expected.to validate_presence_of(:unemat_bond) }
  it { is_expected.to validate_inclusion_of(:unemat_bond).in_array(['Professor', 'Aluno', 'Colaborador Externo']) }

  it { is_expected.to belong_to(:user) }
end
