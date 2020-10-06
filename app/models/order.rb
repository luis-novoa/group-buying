class Order < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :total, presence: true, numericality: true
  validates :delivery_city, presence: true, inclusion: { in: %w[Sinop Cuiabá] }
  validates :status, presence: true, inclusion: { in: %w[Carrinho Processando Pago Entregue] }

  belongs_to :user, optional: false
  belongs_to :purchase_product, optional: false
end
