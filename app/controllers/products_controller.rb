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
      flash[:notice] = 'Produto adicionado!'
      redirect_to product_path(@new_product)
    else
      flash.now[:alert] = @new_product.errors.full_messages
      suppliers_list
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def index
    @products = Product.includes(:partner).joins(:partner).merge(Partner.all).order(:name)
  end

  def edit
    suppliers_list
    @product = Product.find(params[:id])
  end

  def update
    parameters = product_params
    @product = Product.find(params[:id])
    if parameters[:image]
      @product.image.purge
      compress_image(parameters[:image])
    end
    @product.image.purge if destroy_image_request && destroy_image_request[:confirm] == '1'
    if @product.update(parameters)
      flash[:notice] = 'Produto atualizado!'
      redirect_to product_path(@product)
    else
      flash.now[:alert] = @product.errors.full_messages
      suppliers_list
      render :edit
    end
  end

  def destroy
    Product.find(params[:id]).delete
    flash[:notice] = 'Produto apagado!'
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :weight, :weight_type, :description, :partner_id, :image)
  end

  def destroy_image_request
    return unless params[:delete_image]

    params.require(:delete_image).permit(:confirm)
  end
end
