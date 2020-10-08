class Product < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name, presence: true, length: { minimum: 2, maximum: 75 }
  validates :weight, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :weight_type, presence: true, inclusion: { in: %w[g mL] }
  validates :description, presence: true, length: { minimum: 2, maximum: 5000 }
  validates :partner_id, presence: true

  has_many :purchase_products, dependent: false
  has_one_attached :image
  belongs_to :partner, -> { where(supplier: true) }, inverse_of: :products
end
