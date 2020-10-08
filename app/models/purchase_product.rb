class PurchaseProduct < ApplicationRecord
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :offer_city, presence: true, inclusion: { in: ['Sinop', 'Cuiabá', 'Sinop e Cuiabá'] }

  has_many :orders, dependent: false
  belongs_to :purchase
  belongs_to :product
end
