class ProductsController < ApplicationController
  before_action :only_volunteers, :only_approved_users

  def new
    suppliers_list
    @new_product = Product.new
  end

  def create
    parameters = product_params
    compress_image(parameters[:image]) if parameters[:image]
    @new_product = Product.new(parameters)
    if @new_product.save
      flash[:success] = 'Produto adicionado!'
      redirect_to product_path(@new_product)
    else
      flash[:alert] = @new_product.errors.full_messages
      render :new
    end
  end

  def index; end

  def edit; end

  def update; end

  def destroy; end

  private

  def product_params
    params.require(:product).permit(:name, :short_description, :description, :partner_id, :image)
  end

  def suppliers_list
    partners = Partner.all.where(supplier: true)
    @partner_select = []
    partners.each do |partner|
      @partner_select.push([partner.name, partner.id])
    end
  end
end
