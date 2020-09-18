class UsersController < ApplicationController
  before_action :show_restrictions, only: %i[show]
  before_action :index_restrictions, only: %i[index]
  def show
    @user = User.find(params[:id])
  end

  def index
    @approved_users = User.all.where(waiting_approval: false)
    @buyers = @approved_users.where(account_type: 'Comprador')
    @volunteers = @approved_users.where(account_type: 'Voluntário')
    @delivery_points = @approved_users.where(account_type: 'Ponto de Entrega')
    @pending_users = User.all.where(waiting_approval: true)
  end

  private

  def show_restrictions
    return if current_user.id == params[:id].to_i

    index_restrictions
  end

  def index_restrictions
    return unauthorized(:forbidden) if current_user.account_type == 'Comprador'

    unauthorized(:need_approval) if current_user.waiting_approval
  end
end
