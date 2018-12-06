require "XML_security_saml2"

class EidasSaml < OneLogin::RubySaml::Authrequest

  include SamlSessionsHelper

  def create(settings, params = nil)
    #binding.pry
    params = create_params(settings, params)
    params_prefix = (settings.idp_sso_target_url =~ /\?/) ? '&' : '?'
    saml_request = CGI.escape(params.delete("SAMLRequest"))
    request_params = "#{params_prefix}SAMLRequest=#{saml_request}"
    params.each_pair do |key, value|
      request_params << "&#{key.to_s}=#{CGI.escape(value.to_s)}"
    end
    raise "Invalid settings, idp_sso_target_url is not set!" if settings.idp_sso_target_url.nil?
    @login_url = settings.idp_sso_target_url
  end

  def create_authentication_xml_doc(settings)
    document = create_xml_document(settings)
    sign_document(document, settings)
  end

  def create_params(settings, params = nil)
    # The method expects :RelayState but sometimes we get 'RelayState' instead.
    # Based on the HashWithIndifferentAccess value in Rails we could experience
    # conflicts so this line will solve them.
    relay_state = params[:RelayState] || params['RelayState']

    if relay_state.nil?
      params.delete(:RelayState)
      params.delete('RelayState')
    end

    request_doc = create_authentication_xml_doc(settings)
    #binding.pry
    request_doc.context[:attribute_quote] = :quote if settings.double_quote_xml_attribute_values

    request = ""
    request_doc.write(request)

    #request = deflate(request) if settings.compress_request
    base64_request = encode(request)
    request_params = {"SAMLRequest" => base64_request}

    if settings.security[:authn_requests_signed] && !settings.security[:embed_sign] && settings.private_key
      params['SigAlg']    = settings.security[:signature_method]
      url_string = OneLogin::RubySaml::Utils.build_query(
          :type => 'SAMLRequest',
          :data => base64_request,
          :relay_state => relay_state,
          :sig_alg => params['SigAlg']
      )
      sign_algorithm = XMLSecurity::BaseDocument.new.algorithm(settings.security[:signature_method])
      signature = settings.get_sp_key.sign(sign_algorithm.new, url_string)
      params['Signature'] = encode(signature)
    end

    params.each_pair do |key, value|
      request_params[key] = value.to_s
    end

    request_params
  end

  def generate_id
     "_" + rand(16**42).to_s(16)
  end

  def create_xml_document(settings)
    time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
    #uu = generate_id
    request_doc = XMLSecuritySAML2.new
    request_doc.uuid = uuid

    root = request_doc.add_element "saml2p:AuthnRequest", { "xmlns:saml2p" => "urn:oasis:names:tc:SAML:2.0:protocol", "xmlns:saml2" => "urn:oasis:names:tc:SAML:2.0:assertion", "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#", "xmlns:eidas" => "http://eidas.europa.eu/saml-extensions" }
    root.attributes['ID'] = uuid
    root.attributes['IssueInstant'] = time
    root.attributes['Version'] = "2.0"
    root.attributes['ProviderName'] = "ERASMUS-ETSIT"
    root.attributes['Destination'] = settings.idp_sso_target_url unless settings.idp_sso_target_url.nil?
    root.attributes['IsPassive'] = settings.passive unless settings.passive.nil?
    root.attributes['ProtocolBinding'] = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
    root.attributes["AttributeConsumingServiceIndex"] = settings.attributes_index unless settings.attributes_index.nil?
    root.attributes['ForceAuthn'] = settings.force_authn unless settings.force_authn.nil?
    root.attributes['Consent'] = "urn:oasis:names:tc:SAML:2.0:consent:unspecified"

    # Conditionally defined elements based on settings
    if settings.assertion_consumer_service_url != nil
      root.attributes["AssertionConsumerServiceURL"] = settings.assertion_consumer_service_url
      root.attributes["ForceAuthn"] = "true"
    end
    if settings.issuer != nil
      issuer = root.add_element "saml2:Issuer"
      issuer.attributes["Format"] = "urn:oasis:names:tc:SAML:2.0:nameid-format:entity"
      issuer.text = settings.issuer
    end


    extension = root.add_element "saml2p:Extensions"
    sptype = extension.add_element "eidas:SPType"
    sptype.text = "public"
    requested_attributes = extension.add_element "eidas:RequestedAttributes"
    attrs = get_eidas_requested_attrs
    # Add requested attributes to SAML request
    attrs.each do |attr|
      requested_attributes.add_element "eidas:RequestedAttribute", { "Name" => attr["Name"], "FriendlyName" => attr["FriendlyName"], "NameFormat" => attr["NameFormat"], "isRequired" => attr["isRequired"]}
    end
    puts "REQUESTED_ATTRS\n"
    puts requested_attributes
    if settings.name_identifier_format != nil
      root.add_element "saml2p:NameIDPolicy", {
          # Might want to make AllowCreate a setting?
          "AllowCreate" => "true",
          "Format" => "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
      }
    end

    if settings.authn_context || settings.authn_context_decl_ref

      if settings.authn_context_comparison != nil
        comparison = settings.authn_context_comparison
      else
        comparison = 'minimum'
      end

      requested_context = root.add_element "saml2p:RequestedAuthnContext", {
          "Comparison" => comparison,
      }

      if settings.authn_context != nil
        authn_contexts_class_ref = settings.authn_context.is_a?(Array) ? settings.authn_context : [settings.authn_context]
        authn_contexts_class_ref.each do |authn_context_class_ref|
          class_ref = requested_context.add_element "saml2:AuthnContextClassRef"
          class_ref.text = "http://eidas.europa.eu/LoA/low"
        end
      end

      if settings.authn_context_decl_ref != nil
        authn_contexts_decl_refs = settings.authn_context_decl_ref.is_a?(Array) ? settings.authn_context_decl_ref : [settings.authn_context_decl_ref]
        authn_contexts_decl_refs.each do |authn_context_decl_ref|
          decl_ref = requested_context.add_element "saml2:AuthnContextDeclRef"
          decl_ref.text = authn_context_decl_ref
        end
      end
    end



    #nameidpolicy = root.add_element "saml2p:NameIDPolicy", { "AllowCreate" => "true", "Format" => "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"}
    #nameidpolicy.add_element "AllowCreate", "true"
    #nameidpolicy.add_element  "Format", "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"

    #requestedauthcontext = root.add_element "saml2p:RequestedAuthnContext", { "Comparison" => "minimum"}
    #authcontextclassref = requestedauthcontext.add_element "saml2:AuthnContextClassRef"

    request_doc
  end

  def initialize
    super
  end

  def sign_document(document, settings)
    raw_cert = File.read(Rails.root + 'vendor/certs/cert.pem')
    raw_key = File.read(Rails.root + 'vendor/certs/key.pem')

    formatted_public_key =  OpenSSL::X509::Certificate.new(raw_cert)
    formatted_private_key = OpenSSL::PKey::RSA.new(raw_key)
    document.sign_document(formatted_private_key, formatted_public_key, XMLSecurity::Document::RSA_SHA256, XMLSecurity::Document::SHA256)
    
    document
  end


end