class OrdersController < ApplicationController
  def create
    new_order = Order.new(order_params)
    new_order.save
  end

  def update
    order = Order.find(order_params[:id])
    order.update(order_params) if order.status == 'Carrinho'
  end

  def index; end

  private

  def order_params
    params.require(:order).permit(:id, :quantity, :delivery_city, :user_id, :purchase_product_id)
  end
end
