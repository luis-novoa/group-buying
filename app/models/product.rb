class Product < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name, presence: true, length: { minimum: 2, maximum: 75 }
  validates :weigth, presence: true, numericality: { only_integer: true }
  validates :description, presence: true, length: { minimum: 2, maximum: 5000 }
  validates :partner_id, presence: true

  has_many :purchase_products, dependent: false
  has_one_attached :image
  belongs_to :partner, -> { where(supplier: true) }, inverse_of: :products
end
