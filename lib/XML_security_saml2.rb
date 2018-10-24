class XMLSecuritySAML2 < XMLSecurity::Document
  def sign_document(private_key, certificate, signature_method = nil, digest_method = nil)
    noko = Nokogiri::XML(self.to_s) do |config|
      config.options = XMLSecurity::BaseDocument::NOKOGIRI_OPTIONS
    end

    signature_element = REXML::Element.new("ds:Signature").add_namespace('ds', DSIG)
    signed_info_element = signature_element.add_element("ds:SignedInfo")
    signed_info_element.add_element("ds:CanonicalizationMethod", {"Algorithm" => C14N})
    signed_info_element.add_element("ds:SignatureMethod", {"Algorithm"=>signature_method})

    # Add Reference
    reference_element = signed_info_element.add_element("ds:Reference", {"URI" => ""})

    # Add Transforms
    transforms_element = reference_element.add_element("ds:Transforms")
    transforms_element.add_element("ds:Transform", {"Algorithm" => ENVELOPED_SIG})
    c14element = transforms_element.add_element("ds:Transform", {"Algorithm" => C14N})
    c14element.add_element("ec:InclusiveNamespaces", {"xmlns:ec" => C14N, "PrefixList" => INC_PREFIX_LIST})

    digest_method_element = reference_element.add_element("ds:DigestMethod", {"Algorithm" => digest_method})
    inclusive_namespaces = INC_PREFIX_LIST.split(" ")
    canon_doc = noko.canonicalize(canon_algorithm(C14N), inclusive_namespaces)
    reference_element.add_element("ds:DigestValue").text = compute_digest(canon_doc, algorithm(digest_method_element))

    # add SignatureValue
    noko_sig_element = Nokogiri::XML(signature_element.to_s) do |config|
      config.options = XMLSecurity::BaseDocument::NOKOGIRI_OPTIONS
    end

    noko_signed_info_element = noko_sig_element.at_xpath('//ds:Signature/ds:SignedInfo', 'ds' => DSIG)
    canon_string = noko_signed_info_element.canonicalize(canon_algorithm(C14N))

    signature = compute_signature(private_key, algorithm(signature_method).new, canon_string)
    signature_element.add_element("ds:SignatureValue").text = signature

    # add KeyInfo
    key_info_element       = signature_element.add_element("ds:KeyInfo")
    x509_element           = key_info_element.add_element("ds:X509Data")
    x509_cert_element      = x509_element.add_element("ds:X509Certificate")
    if certificate.is_a?(String)
      certificate = OpenSSL::X509::Certificate.new(certificate)
    end
    x509_cert_element.text = Base64.encode64(certificate.to_der).gsub(/\n/, "")

    # add the signature
    issuer_element = self.elements["//saml2:Issuer"]
    extensions = self.elements["//md:Extensions"]
    if issuer_element
      self.root.insert_after issuer_element, signature_element
    elsif extensions
      self.root.insert_before extensions, signature_element
    else
      if sp_sso_descriptor = self.elements["/md:EntityDescriptor"]
        self.root.insert_before sp_sso_descriptor, signature_element
      else
        self.root.add_element(signature_element)
      end
    end
  end
end