module SamlSessionsHelper

  def generate_metadata

  end
  def saml_attrs_to_model_attrs
  	{
  		 "PersonIdentifier" => "person_identifier",
  		 "FamilyName" => "family_name",
  		 "FirstName" => "first_name",
  		 "DateOfBirth" => "birth_date"
  	}

  end

  def get_eidas_requested_attrs
    [
      { "Name" => "http://eidas.europa.eu/attributes/naturalperson/CurrentFamilyName", "FriendlyName" => "FamilyName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
      { "Name" => "http://eidas.europa.eu/attributes/naturalperson/CurrentGivenName", "FriendlyName" => "FirstName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
      { "Name" => "http://eidas.europa.eu/attributes/naturalperson/DateOfBirth", "FriendlyName" => "DateOfBirth", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
      { "Name" => "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier", "FriendlyName" => "PersonIdentifier", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
      { "Name" => "http://eidas.europa.eu/attributes/legalperson/LegalName", "FriendlyName" => "LegalName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
      { "Name" => "http://eidas.europa.eu/attributes/legalperson/LegalPersonIdentifier", "FriendlyName" => "LegalPersonIdentifier", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"}
    ]
  end
end