class PurchaseProduct < ApplicationRecord
  validates :price, presence: true, numericality: true
  validates :quantity, numericality: { only_integer: true }
  validates :offer_city, presence: true, inclusion: { in: %w[Sinop Cuiabá Ambas] }

  has_many :orders, dependent: false
  belongs_to :purchase
  belongs_to :product
end
