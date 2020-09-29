class PurchasesController < ApplicationController
  before_action :only_approved_users
  before_action :except_buyers, only: %i[show index]
  before_action :only_volunteers, except: %i[show index]

  def create
    new_purchase = Purchase.new(purchase_params)
    new_purchase.save
    redirect_to purchase_path(new_purchase)
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def index; end

  def edit; end

  def update; end

  private

  def purchase_params
    params.require(:purchase).permit(:partner_id)
  end
end
