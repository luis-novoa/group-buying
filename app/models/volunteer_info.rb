class VolunteerInfo < ApplicationRecord
  validates :facebook, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :instagram, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :lattes, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :institution, presence: true, length: { minimum: 2, maximum: 75 }
  validates :degree, presence: true, length: { minimum: 2, maximum: 75 }
  validates :unemat_bond, presence: true, inclusion: { in: ['Professor', 'Aluno', 'Colaborador Externo'] }

  belongs_to :user
end
