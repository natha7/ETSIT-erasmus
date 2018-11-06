require "eidas-saml"
require "eidas-metadata"

class SamlSessionsController < Devise::SamlSessionsController
  after_action :store_winning_strategy, only: :create

  def new
    idp_entity_id = get_idp_entity_id(params)
    request = EidasSaml.new
    auth_params = { RelayState: relay_state } if relay_state
    action = request.create(saml_config(idp_entity_id), auth_params || {})
    redirect_to action
  end

  def eidas
    idp_entity_id = get_idp_entity_id(params)
    request = EidasSaml.new
    @post_params = request.create_params(saml_config(idp_entity_id), 'RelayState' => 'MyRelayState')
    #@post_params["postLocationUrl"] = "http://pruebas.etsit.upm.es"
    #@post_params["redirectLocationUrl"] = "http://pruebas.etsit.upm.es"
    @post_params["country"] = "ES"
    #@post_params["sendMethods"] = "POST"
    @login_url = saml_config(idp_entity_id).idp_sso_target_url
    render "users/eidas"
  end

  def eidas_endpoint
      mail(to: "bertocode@gmail.com", subject: "Logs") do |format|
        format.text { render plain: request }
      end
  end

  def metadata
    #metadata = EidasMetadata.new
    #xml = metadata.generate(CONFIG)
	  #render :plain=> xml, :content_type=> "application/xml"
    xml = File.read("#{Rails.root}/public/metadata.xml")
    render :plain=> xml, :content_type=> "application/xml"
  end

  private

  def store_winning_strategy
    warden.session(:user)[:strategy] = warden.winning_strategies[:user].class.name.demodulize.underscore.to_sym
  end
end