class PurchaseProductsController < ApplicationController
  include ProductsHelper
  skip_before_action :check_session, only: %i[index show]
  before_action :only_approved_users, only: %i[new create update destroy]
  before_action :only_volunteers, only: %i[new create update destroy]

  def index
    @purchase_products = PurchaseProduct
                         .joins(:purchase)
                         .includes(product: [{ image_attachment: :blob }])
                         .where(purchases: { active: true })
                         .where(hidden: false)
    @purchase_products = @purchase_products&.paginate(page: params[:page], per_page: 12)&.order(:name)
    @purchase_products ||= []
    if current_user
      @existing_orders = current_user.orders
                                     .where(status: 'Carrinho')
                                     .or(current_user.orders.where(status: 'Processando'))
      @existing_orders_ids = @existing_orders.pluck(:purchase_product_id)
    end
    [@purchase_products, @existing_orders, @existing_orders_ids]
  end

  def show
    @purchase_product = PurchaseProduct
                        .includes(product: { image_attachment: :blob, partner: { image_attachment: :blob } })
                        .find(params[:id])
    @product = @purchase_product.product
    @partner = @product.partner
    [@purchase_product, @product, @partner]
  end

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
    @new_purchase_product.name = product.name + ' ' + format_weight(product.weight, product.weight_type)
    if @new_purchase_product.save
      flash[:notice] = 'Produto adicionado!'
      redirect_to purchase_path(parameters[:purchase_id])
    else
      flash.now[:alert] = @new_purchase_product.errors.full_messages
      products_list
      params[:purchase_id] = parameters[:purchase_id]
      render :new
    end
  end

  def update
    purchase_product = PurchaseProduct.includes(:purchase).find(params[:id])
    purchase_product.update(hidden: params[:hide])
    redirect_to purchase_path(purchase_product.purchase)
  end

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
      product_option = product.name + ' ' + format_weight(product.weight, product.weight_type)
      @product_select.push([product_option, product.id]) unless offered_products.include?(product_option)
    end
  end
end
