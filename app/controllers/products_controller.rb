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

  def show
    @product = Product.find(params[:id])
  end

  def index
    @products = Product.all
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
    if @product.update(parameters)
      flash[:success] = 'Produto atualizado!'
      redirect_to product_path(@product)
    else
      flash[:alert] = @product.errors.full_messages
      render :edit
    end
  end

  def destroy
    Product.find(params[:id]).delete
    flash[:success] = 'Produto apagado!'
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :weigth, :description, :partner_id, :image)
  end
end
