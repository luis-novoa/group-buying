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
            uniqueness: true,
            length: { minimum: 14, maximum: 14 },
            format: /\A\d{14}\z/
  validates :description, presence: true, length: { minimum: 2, maximum: 5000 }
  validates :website, allow_nil: true, length: { maximum: 75 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 },
            format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :ddd1,
            presence: true,
            numericality: { only_integer: true, greater_than: 10, less_than: 100 }
  validates :phone1,
            presence: true,
            numericality: { only_integer: true, greater_than: 10_000_000, less_than: 1_000_000_000 }
  validates :phone1_type, presence: true, inclusion: { in: ['Fixo', 'Celular com Whatsapp', 'Celular sem Whatsapp'] }
  validates :ddd2,
            presence: true,
            numericality: { only_integer: true, greater_than: 10, less_than: 100 },
            unless: -> { phone2.blank? }
  validates :phone2,
            presence: true,
            numericality: { only_integer: true, greater_than: 10_000_000, less_than: 1_000_000_000 },
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

  has_many :purchases, dependent: false
  has_many :products, dependent: false
  has_one_attached :image
  belongs_to :user, -> { where(account_type: 'Ponto de Entrega') }, optional: true, inverse_of: :partner
end
