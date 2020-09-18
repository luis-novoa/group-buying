class UsersController < ApplicationController
  before_action :check_current_user, only: %i[show]
  before_action :check_approval, only: %i[index]
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

  def check_current_user
    unauthorized('O acesso a esta página não é permitido para sua conta.') unless current_user.id == params[:id].to_i
  end

  def check_approval
    return unless current_user.waiting_approval

    unauthorized(
      'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa '\
      'para que você possa acessar esta página.'
    )
  end
end
