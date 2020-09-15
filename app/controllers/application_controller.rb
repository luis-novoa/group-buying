class ApplicationController < ActionController::Base
  before_action :check_volunteer_info, if: -> { current_user && current_user.account_type == 'Voluntário' }

  def check_volunteer_info
    return unless current_user.volunteer_info.nil?

    flash[:notice] = 'Complete seu cadastro para prosseguir'
    redirect_to new_volunteer_info_path
  end
end
