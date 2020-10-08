class Order < ApplicationRecord
  before_save :check_city, :calculate_total

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :delivery_city, presence: true, inclusion: { in: %w[Sinop Cuiabá] }
  validates :status, presence: true, inclusion: { in: %w[Carrinho Processando Pago Entregue] }

  belongs_to :user, optional: false
  belongs_to :purchase_product, optional: false

  private

  def check_city
    throw :abort if ['Sinop e Cuiabá', delivery_city].none?(purchase_product.offer_city)
  end

  def calculate_total
    self.total = quantity * purchase_product.price
  end
end
