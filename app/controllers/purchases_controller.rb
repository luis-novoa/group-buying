class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.includes(:product).where(active: true)
  end
end
