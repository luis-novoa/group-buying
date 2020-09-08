class Purchase < ApplicationRecord
  validates :price, presence: true, numericality: true
  validates :limited_quantity, presence: true
  validates :quantity, numericality: { only_integer: true }
  validates :status, inclusion: { in: ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada'] }
  validates :total, presence: true, numericality: true
  validates :message, length: { maximum: 500 }, allow_nil: true
  validates :product_id, presence: true
end
