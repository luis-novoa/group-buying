class OrdersController < ApplicationController
  def create
    new_order = Order.new(order_params)
    new_order.save
  end

  def update
    order = Order.find(order_params[:id])
    order.update(order_params) if order.status == 'Carrinho'
  end

  def index
    @orders = Order.includes(:purchase_product).where(status: 'Carrinho', user_id: current_user.id)
  end

  def destroy
    order = Order.find(params[:id])
    order.delete if order.status == 'Carrinho'
  end

  private

  def order_params
    params.require(:order).permit(:id, :quantity, :delivery_city, :user_id, :purchase_product_id)
  end
end
