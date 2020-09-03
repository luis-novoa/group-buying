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
  end
end
