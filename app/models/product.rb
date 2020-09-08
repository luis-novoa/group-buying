class Product < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name, presence: true, length: { minimum: 2, maximum: 75 }
  validates :description, presence: true, length: { minimum: 2, maximum: 500 }
  validates :partner_id, presence: true

  has_many :purchases, dependent: false
  belongs_to :partner
end
