class PurchaseListsController < ApplicationController
  before_action :only_approved_users, :except_buyers
  def index
    purchase_products = PurchaseProduct
                        .includes(orders: :user)
                        .joins(:purchase)
                        .merge(Purchase.where(status: 'Pronto para Retirada'))
    @users = []
    purchase_products.each do |purchase_product|
      purchase_product.orders.each do |order|
        @users << order.user
      end
    end
    @users.uniq!
  end

  def show; end
end
