class Purchase < ApplicationRecord
  validates :price, presence: true, numericality: true
  validates :quantity, numericality: { only_integer: true }
  validates :status, inclusion: { in: ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada'] }
  validates :offer_city, presence: true, inclusion: { in: %w[Sinop Cuiabá Ambas] }
  validates :total, presence: true, numericality: true
  validates :message, length: { maximum: 500 }, allow_nil: true
  validates :product_id, presence: true

  has_many :orders, dependent: false
  belongs_to :product
end
