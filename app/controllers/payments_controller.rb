require 'httparty'

class PaymentsController < ApplicationController
  before_action :check_user_id, only: %i[show destroy]

  def create
    new_payment = current_user.payments.build
    new_payment.save
    new_payment.update(ref: "PGTO#{new_payment.id}")
    orders = current_user.orders.where(status: 'Carrinho')
    orders.update_all(status: 'Processando', payment_id: new_payment.id, delivery_city: params[:city])
    redirect_to payment_path(new_payment)
  end

  def show
    @orders = @payment.orders
    @total = @orders.pluck(:total).sum
    [@payment, @orders, @total]
  end

  def destroy
    @payment.destroy if @payment.orders.all? { |order| order.status == 'Processando' }
    redirect_to user_path(current_user)
  end

  private

  def check_user_id
    @payment = Payment.includes(orders: :purchase_product).find(params[:id])
    unauthorized(:forbidden) unless current_user == @payment.user
  end
end
