class User < ApplicationRecord
  before_save :capitalize_first_letter
  before_create :set_need_for_approval
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 50 }
  validates :email, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :password, length: { minimum: 6, maximum: 50 }, on: :create
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
  validates :account_type, presence: true, inclusion: { in: ['Comprador', 'Voluntário', 'Ponto de Entrega'] }
  validates :cpf,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 13, maximum: 19 },
            format: /\d{3}\.\d{3}\.\d{3}-\d{2}/

  has_many :orders, dependent: false
  has_one :partner, dependent: false
  has_one :volunteer_info, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def set_need_for_approval
    self.waiting_approval = true unless account_type == 'Comprador'
  end
end
