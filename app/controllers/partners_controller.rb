class PartnersController < ApplicationController
  before_action :user_filter, only: %i[new create]
  before_action :check_delivery_user, only: %i[new]

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      flash[:success] = 'Parceiro adicionado!'
      redirect_to partners_path
    else
      flash[:alert] << @partner.errors
      render :new
    end
  end

  def index; end

  private

  def user_filter
    return unauthorized(:forbidden) if current_user.account_type == 'Comprador'

    unauthorized(:need_approval) if current_user.waiting_approval
  end

  def check_delivery_user
    unauthorized(:forbidden) if current_user.account_type == 'Ponto de Entrega' && !current_user.partner.nil?
  end

  def partner_params
    params
      .require(:partner)
      .permit(
        :name, :official_name, :supplier, :description, :cnpj, :address, :city, :state,
        :website, :email, :phone1, :phone1_type, :phone2, :phone2_type
      )
  end
end
