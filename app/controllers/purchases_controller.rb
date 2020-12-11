class PurchasesController < ApplicationController
  before_action :only_approved_users
  before_action :except_buyers, only: %i[show index]
  before_action :only_volunteers, except: %i[show index]

  def create
    new_purchase = Purchase.new(create_purchase_params)
    new_purchase.active = false
    new_purchase.save
    redirect_to purchase_path(new_purchase)
  end

  def show
    @purchase = Purchase.includes(:purchase_products).find(params[:id])
    @purchase_products = @purchase.purchase_products.includes(:orders).order(:name)
    [@purchase, @purchase_products]
  end

  def index
    @active_purchases = Purchase.all.where(active: true).order(created_at: :desc).includes(:partner)
    @inactive_purchases = Purchase.all.where(active: false).order(created_at: :desc).includes(:partner)
  end

  def edit
    @purchase = Purchase.find(params[:id])
  end

  def update
    @purchase = Purchase.find(params[:id])
    # if @purchase.total.zero? && update_purchase_params[:active] == 'false'
    #   @purchase.destroy
    #   flash[:alert] = 'Compra apagada!'
    #   redirect_to purchases_path
    #   return
    # end

    if @purchase.update(update_purchase_params)
      flash[:notice] = 'Compra atualizada!'
      redirect_to purchase_path(@purchase)
    else
      flash[:alert] = @purchase.errors.full_messages
      render :edit
    end
  end

  private

  def create_purchase_params
    params.require(:purchase).permit(:partner_id)
  end

  def update_purchase_params
    params.require(:purchase).permit(:active, :status)
  end
end
