# frozen_string_literal: true
require "eidas-saml"

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  include DeviseSamlAuthenticatable::SamlConfig
  # GET /resource/sign_in
   def new
     idp_entity_id = get_idp_entity_id(params)
     request = EidasSaml.new
     @post_params = request.create_params(saml_config(idp_entity_id), 'RelayState' => 'MyRelayState')
     #@post_params["postLocationUrl"] = "http://pruebas.etsit.upm.es"
     #@post_params["redirectLocationUrl"] = "http://pruebas.etsit.upm.es"
     @post_params["country"] = "ES"
     #@post_params["sendMethods"] = "POST"
     @login_url = saml_config(idp_entity_id).idp_sso_target_url
     super
   end

  # POST /resource/sign_in
   def create
     super
   end

  # DELETE /resource/sign_out
   def destroy
     super
   end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
