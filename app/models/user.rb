class User < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 50 }
  validates :email, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :password, length: { minimum: 6, maximum: 50 }
  validates :address,
            presence: true,
            length: { minimum: 2, maximum: 75 },
            format: %r{\A(\w+ )+(\w+), (\d+|s/n)(\z|.+\z)}i
  validates :city, presence: true, length: { minimum: 2, maximum: 30 }
  validates :state, presence: true, inclusion: { in: %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ
                                                        RN RO RS RR SC SE SP TO] }
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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable # , :confirmable

  def capitalize_first_letter
    name = self.name.split(' ')
    name.map! do |e|
      e.capitalize! unless %w[do da dos das e].include?(e)
      e
    end
    self.name = name.join(' ')
    self
  end
end
