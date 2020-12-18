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

    if @purchase.update(update_purchase_params)
      flash[:notice] = 'Compra atualizada!'
      redirect_to purchase_path(@purchase)
    else
      flash[:alert] = @purchase.errors.full_messages
      render :edit
    end
  end

  def destroy
    @purchase = Purchase.find(params[:id])
    if @purchase.purchase_products.empty?
      @purchase.destroy
      redirect_to purchases_path
    else
      flash[:notice] = 'Impossível apagar compra coletiva que possui produtos ofertados!'
      redirect_to user_path(current_user)
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
