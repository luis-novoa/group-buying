class VolunteerInfo < ApplicationRecord
  validates :address,
            presence: true,
            length: { minimum: 2, maximum: 75 },
            format: %r{\A.+, (\d+|s/n)(\z|.+\z)}i
  validates :city, presence: true, length: { minimum: 2, maximum: 30 }
  validates :state,
            presence: true,
            inclusion: {
              in: %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RO RS RR SC SE SP TO]
            }
  validates :facebook, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :instagram, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :lattes, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :institution, presence: true, length: { minimum: 2, maximum: 75 }
  validates :degree, presence: true, length: { minimum: 2, maximum: 75 }
  validates :unemat_bond, presence: true, inclusion: { in: ['Professor', 'Aluno', 'Colaborador Externo'] }

  belongs_to :user
end
