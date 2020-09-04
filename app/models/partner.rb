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
end
