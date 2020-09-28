class Purchase < ApplicationRecord
  validates :status, inclusion: { in: ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada'] }
  validates :total, presence: true, numericality: true
  validates :message, length: { maximum: 500 }, allow_nil: true

  has_many :purchase_products, dependent: false
  belongs_to :partner
end
