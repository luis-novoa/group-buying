# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :adjust_address_and_phone, :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.

  # rubocop:disable Metrics/AbcSize
  def adjust_address_and_phone
    params[:user][:address] += ", #{params[:address_number]}"
    params[:user][:address] += ", #{params[:address_additional_info]}" unless params[:address_additional_info] == ''
    params[:user][:phone1] = "(#{params[:ddd1]}) #{params[:phone1_first_half]}-#{params[:phone1_second_half]}"
    return if params[:ddd2] == '' && params[:phone2_first_half] == '' && params[:phone2_second_half] == ''

    params[:user][:phone2] = "(#{params[:ddd2]}) #{params[:phone2_first_half]}-#{params[:phone2_second_half]}"
  end
  # rubocop:enable Metrics/AbcSize

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[name address city state phone1 phone1_type phone2 phone2_type account_type]
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
