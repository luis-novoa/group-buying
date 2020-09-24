class PartnersController < ApplicationController
  before_action :user_filter, only: %i[new create index show edit]
  before_action :check_delivery_user, only: %i[new]
  before_action :only_volunteers, only: %i[index show edit]

  def new
    @partner = Partner.new
  end

  def create
    parameters = partner_params
    compress_image(parameters[:image]) if parameters[:image]
    @partner = Partner.new(parameters)
    if @partner.save
      flash[:success] = 'Parceiro adicionado!'
      redirect_to partners_path
    else
      flash[:alert] = @partner.errors.full_messages
      render :new
    end
  end

  def index; end

  def show; end

  def edit; end

  private

  def user_filter
    return unauthorized(:forbidden) if current_user.account_type == 'Comprador'

    unauthorized(:need_approval) if current_user.waiting_approval
  end

  def check_delivery_user
    unauthorized(:forbidden) if current_user.account_type == 'Ponto de Entrega' && !current_user.partner.nil?
  end

  def only_volunteers
    unauthorized(:forbidden) unless current_user.account_type == 'Voluntário'
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
