class PurchaseListsController < ApplicationController
  before_action :only_approved_users, :except_buyers
  def index
    purchase_products = PurchaseProduct
                        .includes(orders: :user)
                        .joins(:purchase)
                        .merge(Purchase.where(status: 'Pronto para Retirada'))
    @users = []
    purchase_products.each do |purchase_product|
      purchase_product.orders.where(status: 'Pago').each do |order|
        @users << order.user
      end
    end
    @users = @users.uniq.sort_by(&:name)
    @users
  end

  def show
    @buyer = User.find(params[:id])
    @orders = Order.joins(:user, purchase_product: :purchase)
                   .merge(Purchase.where(status: 'Pronto para Retirada'))
                   .merge(User.where(id: params[:id]))
    [@buyer, @orders]
  end

  def update
    @orders = Order.joins(:user, purchase_product: :purchase)
                   .merge(Purchase.where(status: 'Pronto para Retirada'))
                   .merge(User.where(id: params[:id]))
    @orders.update_all(status: 'Entregue')
  end
end
