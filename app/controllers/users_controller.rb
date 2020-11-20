class UsersController < ApplicationController
  before_action :only_approved_users, except: %i[show]
  before_action :check_user_id, only: %i[show]
  before_action :except_buyers, only: %i[index]
  before_action :only_privileged_users, only: %i[update]
  def show
    @user = User.includes(orders: :purchase_product).find(params[:id])
    @orders = @user.orders.where.not(status: 'Carrinho')
    [@user, @orders]
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

  def check_user_id
    except_buyers unless current_user.id == params[:id].to_i
    suppliers_list
    @new_purchase = Purchase.new
  end

  def only_privileged_users
    unauthorized(:forbidden) unless current_user.moderator || current_user.super_user
  end
end
