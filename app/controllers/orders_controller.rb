class OrdersController < ApplicationController
  def create
    new_order = current_user.orders.build(order_params)
    new_order.save
    redirect_to orders_path
  end

  def update
    order = current_user.orders.find(order_params[:id])
    order.update(order_params) if order.status == 'Carrinho'
    redirect_to orders_path
  end

  def index
    @orders = Order.includes(:purchase_product).where(status: 'Carrinho', user_id: current_user.id)
  end

  def destroy
    order = Order.find(params[:id])
    order.delete if order.status == 'Carrinho'
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(:id, :quantity, :delivery_city, :purchase_product_id)
  end
end
