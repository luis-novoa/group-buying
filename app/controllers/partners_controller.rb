class PartnersController < ApplicationController
  before_action :except_buyers, :only_approved_users
  before_action :check_delivery_user, only: %i[new]
  before_action :only_volunteers, only: %i[index show edit update]

  def new
    @partner = Partner.new
  end

  def create
    parameters = partner_params
    compress_image(parameters[:image]) if parameters[:image]
    @partner = Partner.new(parameters)
    if @partner.save
      flash[:success] = 'Parceiro adicionado!'
      redirect_to partner_path(@partner)
    else
      flash[:alert] = @partner.errors.full_messages
      render :new
    end
  end

  def index
    @suppliers = Partner.all.where(supplier: true)
    @delivery_points = Partner.all.where(supplier: false)
  end

  def show
    @partner = Partner.find(params[:id])
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def update
    parameters = partner_params
    @partner = Partner.find(params[:id])
    if parameters[:image]
      @partner.image.purge
      compress_image(parameters[:image])
    end
    if @partner.update(parameters)
      flash[:success] = 'Parceiro adicionado!'
      redirect_to partner_path(@partner)
    else
      flash[:alert] = @partner.errors.full_messages
      render :edit
    end
  end

  private

  def check_delivery_user
    unauthorized(:forbidden) if current_user.account_type == 'Ponto de Entrega' && !current_user.partner.nil?
  end

  def partner_params
    params
      .require(:partner)
      .permit(
        :name, :official_name, :supplier, :description, :cnpj, :address, :city, :state,
        :website, :email, :phone1, :phone1_type, :phone2, :phone2_type, :image
      )
  end
end
