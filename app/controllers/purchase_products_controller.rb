class PurchaseProductsController < ApplicationController
  skip_before_action :check_session, only: %i[index show]
  before_action :only_approved_users, only: %i[new create update destroy]
  before_action :only_volunteers, only: %i[new create update destroy]

  def index
    purchases = Purchase.all.where(status: 'Aberta')
    @purchase_products = []
    purchases.each do |purchase|
      purchase.purchase_products.each do |purchase_product|
        @purchase_products << purchase_product
      end
    end
    if current_user
      @existing_orders = current_user.orders.where.not(status: 'Entregue')
      @existing_orders_ids = @existing_orders.pluck(:purchase_product_id)
    end
    [@purchase_products, @existing_orders, @existing_orders_ids]
  end

  def show; end

  def new
    @purchase = Purchase.find(params[:purchase_id])
    @new_purchase_product = @purchase.purchase_products.build
    products_list
  end

  def create
    parameters = purchase_product_params
    @purchase = Purchase.includes(:purchase_products).find(parameters[:purchase_id])
    @new_purchase_product = PurchaseProduct.new(parameters)
    product = Product.find(parameters[:product_id])
    @new_purchase_product.name = product.name
    if @new_purchase_product.save
      flash[:success] = 'Produto adicionado!'
      redirect_to purchase_path(parameters[:purchase_id])
    else
      flash[:alert] = @new_purchase_product.errors.full_messages
      products_list
      render :new
    end
  end

  def update; end

  def destroy
    purchase_product = PurchaseProduct.find(params[:id])
    purchase_product.delete
    flash[:success] = 'Oferta deletada!'
    redirect_back(fallback_location: purchases_path)
  end

  private

  def purchase_product_params
    params.require(:purchase_product).permit(:product_id, :purchase_id, :price, :quantity, :offer_city)
  end

  def products_list
    products = @purchase.partner.products
    offered_products = @purchase.purchase_products.pluck(:name)
    @product_select = []
    products.each do |product|
      @product_select.push([product.name, product.id]) unless offered_products.include?(product.name)
    end
  end
end
