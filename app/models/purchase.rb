class Purchase < ApplicationRecord
  validates :status, inclusion: { in: ['Aberta', 'Solicitada ao Fornecedor', 'Pronto para Retirada', 'Finalizada'] }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :purchase_products, dependent: :destroy
  belongs_to :partner
end
