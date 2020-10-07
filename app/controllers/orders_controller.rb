class OrdersController < ApplicationController
  def create
    new_order = Order.new(order_params)
    product = PurchaseProduct.find(order_params[:purchase_product_id])
    new_order.total = new_order.quantity * product.price
    new_order.save
  end

  def index; end

  private

  def order_params
    params.require(:order).permit(:quantity, :delivery_city, :user_id, :purchase_product_id)
  end
end
