class PurchasesController < ApplicationController
  skip_before_action :check_session, only: %i[index]

  def index
    @purchases = Purchase.includes(:product).where(active: true)
  end
end
