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
      # @post_params["country"] = "ES"
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
      user_data = JSON.parse(@response)
      Rails.logger.info "#{user_data}"
      if user_data != nil
        @user = User.find_by person_identifier: user_data["PersonIdentifier"]
        if !@user.nil?
          sign_in(:user, @user)
          redirect_to RELATIVE_URL + "/user_dashboard"
        elsif !session[:nominee].blank?
          user = User.new
          user.email = session[:nominee]
          user.password = "demonstration"
          user.save(validate: false)
          user_data.each do |key, value|
            attr = parseEidasAttr(key, value)
            # Rails.logger.info "#{key} #{attr[:key]} #{attr[:value]}"
            if attr[:key] != "unknown"
              if attr[:key] == "languages"
                user.student_application_form.languages << attr[:value]
              elsif attr[:key] == "photo"
                user.photo = attr[:value]
                user.photo_file_name = "photo.jpg"
              else
                if attr[:sap]
                  user.student_application_form[attr[:key]] = attr[:value]
                else
                  user[attr[:key]] = attr[:value]
                end
              end
            end
          end

          user.save(validate: false)

          nominee = NominatedUser.find_by :email => session[:nominee]
          session.delete(:nominee)
          nominee.destroy!
          flash[:notice] = "You have correctly registered with eIDAS"
          sign_in(:user, user)
          @user = user
          redirect_to RELATIVE_URL + "/student_application_form/personal_data_step?register=true"
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