class PartnersController < ApplicationController
  before_action :user_filter, only: %i[new]
  before_action :check_delivery_user, only: %i[new]

  def new; end

  def index; end

  private

  def user_filter
    return unauthorized(:forbidden) if current_user.account_type == 'Comprador'

    unauthorized(:need_approval) if current_user.waiting_approval
  end

  def check_delivery_user
    unauthorized(:forbidden) if current_user.account_type == 'Ponto de Entrega' && !current_user.partner.nil?
  end
end
