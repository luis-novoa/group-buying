class ApplicationController < ActionController::Base
  before_action :check_session
  before_action :check_volunteer_info, if: -> { current_user && current_user.account_type == 'Voluntário' }

  private

  def check_session
    unauthorized unless current_user
  end

  def unauthorized
    flash[:alert] = if current_user
                      ['O acesso a esta página não é permitido para sua conta.']
                    else
                      ['Página disponível apenas para usuários cadastrados.']
                    end
    redirect_to root_path
  end

  def check_volunteer_info
    return unless current_user.volunteer_info.nil?

    flash[:notice] = ['Complete seu cadastro para prosseguir']
    redirect_to new_volunteer_info_path
  end
end
