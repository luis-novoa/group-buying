class Order < ApplicationRecord
  before_validation :check_city, :calculate_total
  after_save :update_parent_purchase

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :delivery_city, presence: true, inclusion: { in: %w[Sinop Cuiabá] }
  validates :status, presence: true, inclusion: { in: %w[Carrinho Processando Aguardando Cancelado Pago Entregue] }

  belongs_to :user, optional: false
  belongs_to :purchase_product, optional: false
  belongs_to :payment, optional: true

  private

  def check_city
    return unless purchase_product

    throw :abort if ['Sinop e Cuiabá', delivery_city].none?(purchase_product.offer_city)
  end

  def calculate_total
    return if quantity.nil? || purchase_product.nil?

    self.total = quantity * purchase_product.price
  end

  def update_parent_purchase
    return unless status == 'Pago'

    old_total = purchase_product.purchase.total
    new_total = old_total + total
    purchase_product.purchase.update(total: new_total)
  end
end
