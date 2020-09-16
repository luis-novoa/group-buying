class UsersController < ApplicationController
  before_action :check_current_user, only: %i[show]
  def show; end

  private

  def check_current_user
    unauthorized unless current_user.id == params[:id]
  end
end
