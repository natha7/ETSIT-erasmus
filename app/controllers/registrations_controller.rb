# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :has_token?, only: [:create]
  before_action :validate_not_user?, only: [:create]
  #before_action :validate_fields, only: [:create]
  # GET /resource/sign_up
  #def new
  #   super
  # end

  # POST /resource
   def create
      if @nominated_user != nil
        params[:user].delete :registration_token
        build_resource(sign_up_params)
        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            @nominated_user.destroy!
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          flash[:error] = resource.errors.full_messages.to_sentence
          clean_up_passwords resource
          set_minimum_password_length
          redirect_back fallback_location: root_path
        end
      else
        flash[:error] = "Token does not exist"
        redirect_to(:root)
      end
   end

  # protected
  def has_token?
    if params[:user][:registration_token]
      @nominated_user = NominatedUser.find_by(registration_token: params[:user][:registration_token])
      true
    else
      false
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:registration_token, :first_name, :family_name, :sex, :birth_date, :born_place, :permanent_adress, :nationality, :phone_number, :seeking_degree, :email, :password, :password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    config.relative_url_root + "/student_application_form/1"
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
   private

  # Notice the name of the method
  def sign_up_params
    params.require(:user).permit(:registration_token, :first_name, :family_name, :sex, :birth_date, :born_place,:permanent_adress, :nationality, :phone_number, :seeking_degree, :email, :password, :password_confirmation)
  end
end
