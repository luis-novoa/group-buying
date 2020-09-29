class PurchaseProductsController < ApplicationController
  skip_before_action :check_session, only: %i[index]

  def index
    purchases = Purchase.all.where(active: true)
    @purchase_products = []
    purchases.each do |purchase|
      purchase.purchase_products.each do |purchase_product|
        @purchase_products << purchase_product
      end
    end
    @purchase_products
  end
end
