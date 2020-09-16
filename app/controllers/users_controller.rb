class UsersController < ApplicationController
  before_action :check_current_user, only: %i[show]
  def show
    @user = User.find(params[:id])
  end

  def index; end

  private

  def check_current_user
    unauthorized unless current_user.id == params[:id].to_i
  end
end
