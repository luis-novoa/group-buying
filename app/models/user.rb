class User < ApplicationRecord
  before_save :capitalize_first_letter
  before_create :set_need_for_approval
  before_update :set_approval_again
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 50 }
  validates :email, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :password, length: { minimum: 6, maximum: 50 }, on: :create
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
  validates :account_type, presence: true, inclusion: { in: ['Comprador', 'Voluntário', 'Ponto de Entrega'] }
  validates :cpf,
            presence: true,
            uniqueness: true,
            length: { minimum: 11, maximum: 11 },
            format: /\A\d{11}\z/

  has_many :orders, dependent: false
  has_many :payments, dependent: false
  has_one :partner, dependent: false
  has_one :volunteer_info, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def set_need_for_approval
    self.waiting_approval = true unless account_type == 'Comprador'
  end

  def set_approval_again
    self.waiting_approval = true if account_type_was == 'Comprador'
  end
end
