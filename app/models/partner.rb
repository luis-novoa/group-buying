class Partner < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 }
  validates :official_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 }
  validates :cnpj,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { is: 18 },
            format: %r{\A\d{2}.\d{3}.\d{3}/\d{4}-\d{2}\z}
  validates :description, presence: true, length: { minimum: 2, maximum: 500 }
  validates :website, allow_nil: true, length: { minimum: 2, maximum: 75 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 },
            format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :phone1,
            presence: true,
            length: { minimum: 14, maximum: 15 },
            format: /\(\d\d\)\ \d{4,5}-\d{4}/
  validates :phone1_type, presence: true, inclusion: { in: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp'] }
  validates :phone2,
            presence: true,
            length: { minimum: 14, maximum: 15 },
            format: /\(\d\d\)\ \d{4,5}-\d{4}/,
            unless: -> { phone2_type.blank? }
  validates :phone2, absence: true, if: -> { phone2_type.blank? }
  validates :phone2_type,
            presence: true,
            inclusion: { in: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp'] },
            unless: -> { phone2.blank? }
  validates :phone2_type, absence: true, if: -> { phone2.blank? }
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
end
