require "eidas-saml"
require "eidas-metadata"
class SamlSessionsController < Devise::SamlSessionsController
  #after_action :store_winning_strategy, only: :create
  include SamlSessionsHelper

  def new
    idp_entity_id = get_idp_entity_id(params)
    request = EidasSaml.new
    auth_params = { RelayState: relay_state } if relay_state
    action = request.create(saml_config(idp_entity_id), auth_params || {})
    redirect_to action
  end

  def eidas
    idp_entity_id = get_idp_entity_id(params)
    @post_params = {}
    node_command = Terrapin::CommandLine.new("node -e 'require(\"./vendor/saml2-node/saml2-gateway.js\").getAuthnRequest()'")

    begin
      @post_params["SAMLRequest"] = node_command.run
      @post_params["RelayState"] = "MyRelayState"
      @post_params["country"] = "ES"
      @login_url = CONFIG["idp_options"]["sso_login_url"]
    rescue Terrapin::ExitStatusError => e
      puts e.message
    end

    render "users/eidas"
  end

  def create
    node_command = Terrapin::CommandLine.new("node -e 'require(\"./vendor/saml2-node/saml2-gateway.js\").decodeAuthnResponse(\"" + params["SAMLResponse"] + "\")'")
    begin
      @response = node_command.run
    rescue Terrapin::ExitStatusError => e
      puts e.message
    end

    if @response != nil
      Rails.logger.info "#{response}"
      user_data = JSON.parse(@response)

      if user_data != nil
        @user = User.find_by person_identifier: user_data["PersonIdentifier"]
        Rails.logger.info "#{user_data}"
        if !@user.nil?
          sign_in(:user, @user)
          redirect_to RELATIVE_URL + "/user_dashboard"
        elsif !session[:nominee].blank?
          user = User.new
          user.email = session[:nominee]
          # TODO Qué pasa cuando un parámetro de user data viene vacío?
          user.password = "demonstration"
          saml_dictionary = saml_attrs_to_model_attrs
          user_data.each do |key,value|
            if saml_dictionary.key?(key)
              user[saml_dictionary[key]] = parseAttribute(key,value)
            elsif saml_dictionary_sap.key?(key)
              Rails.logger.info "#{key} #{saml_dictionary_sap[key]} "
              user.student_application_form[saml_dictionary_sap[key]] = parseAttribute(key,value)
            end
          end

          user.save(validate: false)

          nominee = NominatedUser.find_by :email => session[:nominee]
          session.delete(:nominee)
          nominee.destroy!
          flash[:notice] = "You have correctly registered with eIDAS"
          sign_in(:user, user)
          @user = user
          redirect_to RELATIVE_URL + "/student_application_form/personal_data_step"
        else
         flash[:error] = "You have not registered with eIDAS"
         redirect_to(:root)
        end
      end
    else
     flash[:error] = "Something went wrong"
     redirect_to(:root)
    end

  end

  def metadata
    node_command = Terrapin::CommandLine.new("node -e 'require(\"./vendor/saml2-node/saml2-gateway.js\").getMetadata()'")
    begin
      xml = node_command.run
      xml_doc  = Nokogiri::XML(xml)
    rescue Terrapin::ExitStatusError => e
      puts e.message
    end
    response.headers["Content-Type"] = "application/xml"

    render :plain=> xml
  end

  private

  def store_winning_strategy
    warden.session(:user)[:strategy] = warden.winning_strategies[:user].class.name.demodulize.underscore.to_sym
  end
end