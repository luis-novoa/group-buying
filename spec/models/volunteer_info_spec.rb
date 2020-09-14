require 'rails_helper'

RSpec.describe VolunteerInfo, type: :model do
  subject { build(:volunteer_info) }
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
