class VolunteerInfosController < ApplicationController
  skip_before_action :check_volunteer_info
  before_action :only_volunteers

  def index
    redirect_to new_volunteer_info_path
  end

  def new
    @volunteer_info = VolunteerInfo.new
  end

  def create
    @volunteer_info = current_user.build_volunteer_info(volunteer_info_params)
    if @volunteer_info.save
      redirect_to root_path
    else
      flash.now[:alert] = @volunteer_info.errors.full_messages
      render 'new'
    end
  end

  private

  def volunteer_info_params
    params.require(:volunteer_info).permit(:address, :city, :state, :institution, :degree, :unemat_bond, :instagram, :facebook, :lattes)
  end
end
