require "XML_security_saml2"

class EidasMetadata < OneLogin::RubySaml::Metadata

    # Return SP metadata based on the settings.
    # @param settings [OneLogin::RubySaml::Settings|nil] Toolkit settings
    # @param pretty_print [Boolean] Pretty print or not the response
    # No pretty print if you gonna validate the signature)
    # @return [String] XML Metadata of the Service Provider

    def generate(config)
      meta_doc = XMLSecuritySAML2.new

      raw_cert = File.read(Rails.root + 'vendor/certs/cert.pem')
      raw_key = File.read(Rails.root + 'vendor/certs/key.pem')

      raw_cert = OneLogin::RubySaml::Utils.format_cert(raw_cert)
      formatted_public_key =  OpenSSL::X509::Certificate.new(raw_cert)
      raw_key = OneLogin::RubySaml::Utils.format_private_key(raw_key)
      formatted_private_key = OpenSSL::PKey::RSA.new(raw_key)


      namespaces = {
          "xmlns:md" => "urn:oasis:names:tc:SAML:2.0:metadata",
          "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#",
          "Id" => ""
      }

      root = meta_doc.add_element "md:EntityDescriptor", namespaces

      extensions = root.add_element "md:Extensions"

      entity_attributes = extensions.add_element "mdattr:EntityAttributes", {
          "xmlns:mdattr" => "urn:oasis:names:tc:SAML:metadata:attribute",
          "xmlns:saml2" => "urn:oasis:names:tc:SAML:2.0:assertion",
      }
      attribute1 = entity_attributes.add_element "saml2:Attribute", {
          "Name" => "http://eidas.europa.eu/entity_attributes/protocol-version",
          "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
      }
      inside_attribute1 = attribute1.add_element "saml2:AttributeValue", {
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:type" => "xs:string"
      }
      inside_attribute1.text = "1.1"
      attribute2 =  entity_attributes.add_element "saml2:Attribute", {
          "Name" => "http://eidas.europa.eu/entity-attributes/application-identifier",
          "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri",
      }
      inside_attribute2 = attribute2.add_element "saml2:AttributeValue", {
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xsi:type" => "xs:string"
      }
      inside_attribute2.text = "CEF:eIDAS-ref:1.4.3"

      sp_type = extensions.add_element "eidas:SPType", {
          "xmlns:eidas" => "http://eidas.europa.eu/saml-extensions"
      }
      sp_type.text = "public"

      extensions.add_element "alg:DigestMethod", {
          "xmlns:alg" => "urn:oasis:names:tc:SAML:metadata:algsupport",
          "Algorithm" => "http://www.w3.org/2001/04/xmlenc#sha512"
      }

      extensions.add_element "alg:SigningMethod", {
          "xmlns:alg" => "urn:oasis:names:tc:SAML:metadata:algsupport",
          "Algorithm" => "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512"
      }

      sp_sso = root.add_element "md:SPSSODescriptor", {
          "protocolSupportEnumeration" => "urn:oasis:names:tc:SAML:2.0:protocol",
          "AuthnRequestsSigned" => "true",
          "WantAssertionsSigned" => "true",
      }

      # Add KeyDescriptor if messages will be signed / encrypted
      # with SP certificate, and new SP certificate if any
      cert = formatted_public_key
      #cert_new = nil

      for sp_cert in [cert]
        if sp_cert
          cert_text = Base64.encode64(sp_cert.to_der).gsub("\n", '')
          kd = sp_sso.add_element "md:KeyDescriptor", { "use" => "signing" }
          ki = kd.add_element "ds:KeyInfo", {"xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#"}
          xd = ki.add_element "ds:X509Data"
          xc = xd.add_element "ds:X509Certificate"
          xc.text = cert_text

          kd2 = sp_sso.add_element "md:KeyDescriptor", { "use" => "encryption" }
          ki2 = kd2.add_element "ds:KeyInfo", {"xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#"}
          xd2 = ki2.add_element "ds:X509Data"
          xc2 = xd2.add_element "ds:X509Certificate"
          xc2.text = cert_text

          kd2.add_element "md:EncryptionMethod", {
              "Algorithm" => "http://www.w3.org/2009/xmlenc11#aes256-gcm"
          }
        end
      end

      #root.attributes["ID"] = OneLogin::RubySaml::Utils.uuid
      root.attributes["entityID"] = config["sp_options"]["entity_id"]
      tl = Time.now.localtime
      year = ((tl.year.to_i) + 1).to_s
      root.attributes["validUntil"] =  year + "-" + tl.month.to_s + "-" + tl.day.to_s + "T" + tl.localtime.strftime("%H:%M:%S") + ".802Z"

      nameID = sp_sso.add_element "md:NameIDFormat"
      nameID.text =  "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"

      sp_sso.add_element "md:AssertionConsumerService", {
          "Binding" => "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST",
          "Location" => config["sp_options"]["assert_endpoint"],
          "index" => "0",
          "isDefault" => "true",
      }

      organization = root.add_element "md:Organization"
      org_name = organization.add_element "md:OrganizationName", {
          "xml:lang" => "en"
      }
      org_name.text = config["sp_options"]["organization"]
      org_dispname = organization.add_element "md:OrganizationDisplayName", {
          "xml:lang" => "en"
      }
      org_dispname.text = config["sp_options"]["organization_display"]

      org_url = organization.add_element "md:OrganizationURL", {
          "xml:lang" => "en"
      }
      org_url.text = config["sp_options"]["url"]

      contact_person = root.add_element "md:ContactPerson", {
          "contactType" => "technical"
      }
      contact_person.text = config["sp_options"]["contact"]
      contact_person2 = root.add_element "md:ContactPerson", {
          "contactType" => "support"
      }
      contact_person2.text = config["sp_options"]["contact"]

      # With OpenSSO, it might be required to also include
      #  <md:RoleDescriptor xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:query="urn:oasis:names:tc:SAML:metadata:ext:query" xsi:type="query:AttributeQueryDescriptorType" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"/>
      #  <md:XACMLAuthzDecisionQueryDescriptor WantAssertionsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol"/>

      meta_doc << REXML::XMLDecl.new("1.0", "UTF-8")

      # embed signature
      private_key = formatted_private_key
      meta_doc.sign_document(private_key, cert, XMLSecurity::Document::RSA_SHA512, XMLSecurity::Document::SHA512)

      ret = meta_doc.to_s
      # pretty print the XML so IdP administrators can easily see what the SP supports

      return ret
  end
end