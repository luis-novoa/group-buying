class UsersController < ApplicationController
  before_action :only_approved_users, except: %i[show]
  before_action :check_user_id, only: %i[show]
  before_action :except_buyers, only: %i[index]
  before_action :only_privileged_users, only: %i[update]
  def show
    @user = User.includes(orders: :purchase_product).find(params[:id])
    @orders = @user.orders.where.not(status: 'Carrinho')
    @orders = @orders&.paginate(page: params[:page], per_page: 20)&.order(created_at: :desc)
    [@user, @orders]
  end

  def index
    @approved_users = User.all.where(waiting_approval: false)&.order(:name)
    @buyers = @approved_users.where(account_type: 'Comprador')&.order(:name)
    @volunteers = @approved_users.where(account_type: 'Voluntário')&.order(:name)
    @delivery_points = @approved_users.where(account_type: 'Ponto de Entrega')&.order(:name)
    @pending_users = User.all.where(waiting_approval: true)&.order(:name)
  end

  def update
    user = User.find(params[:id])
    user.update(mod_params)
    flash[:notice] = 'Ação concluída com sucesso!'
    redirect_back(fallback_location: users_path)
  end

  private

  def mod_params
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
