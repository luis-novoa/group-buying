class UsersController < ApplicationController
  before_action :only_approved_users
  before_action :show_restrictions, only: %i[show]
  before_action :index_restrictions, only: %i[index]
  before_action :update_restrictions, only: %i[update]
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

  def update
    User.find(params[:id]).update(mod_params)
    flash[:notice] = 'Ação concluída com sucesso!'
    redirect_back(fallback_location: users_path)
  end

  private

  def mod_params
    params[:waiting_approval] = params[:waiting_approval] == 'true'
    if current_user.super_user
      params.permit(:account_type, :waiting_approval, :moderator)
    else
      params.permit(:account_type, :waiting_approval)
    end
  end

  def show_restrictions
    index_restrictions unless current_user.id == params[:id].to_i
  end

  def index_restrictions
    unauthorized(:forbidden) if current_user.account_type == 'Comprador'
  end

  def update_restrictions
    unauthorized(:forbidden) unless current_user.moderator || current_user.super_user
  end
end
