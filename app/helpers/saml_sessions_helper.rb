
require 'json'

module SamlSessionsHelper
  requested_eidas_attrs = File.read(Rails.root + 'vendor/saml2-node/requested_attributes.json')
  parsed_eidas_attrs = {}
  begin 
    parsed_eidas_attrs = JSON.parse(requested_eidas_attrs)
  rescue
  end
  def generate_metadata

  end
  def saml_attrs_to_model_attrs
  	{
  		 "PersonIdentifier" => "person_identifier",
  		 "FamilyName" => "family_name",
  		 "FirstName" => "first_name",
  		 "DateOfBirth" => "birth_date",
       "PlaceOfBirth" => "born_place",
       "CurrentAddress"  => "permanent_adress",
       "Gender" => "sex"
  	}

  end

  def get_eidas_requested_attrs
    requested_attributes = REQUESTED_EIDAS_ATTRS

    array_natural = ["PersonIdentifier" , "FamilyName", "FirstName", "DateOfBirth", "PlaceOfBirth", "CurrentAddress", "Gender"]
    array_legal = ["LegalPersonIdentifier", "LegalName"]
    array_representative = []

    extensions = {
        'eidas:SPType' => "public",
        'eidas:RequestedAttributes' => []
    }

    attrs = []

    array_natural.each do |attr| 
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute' => requested_attributes["NaturalPerson"][attr]
        })
        attrVal = requested_attributes["NaturalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end
    array_legal.each do |attr| 
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute' => requested_attributes["LegalPerson"][attr]
        })
        attrVal = requested_attributes["NaturalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end
    array_representative.each do |attr| 
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute' => requested_attributes["RepresentativeNaturalPerson"][attr]
        })
        attrVal = requested_attributes["NaturalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end

    puts extensions

    # [
    #   { "Name" => "http://eidas.europa.eu/attributes/naturalperson/CurrentFamilyName", "FriendlyName" => "FamilyName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
    #   { "Name" => "http://eidas.europa.eu/attributes/naturalperson/CurrentGivenName", "FriendlyName" => "FirstName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
    #   { "Name" => "http://eidas.europa.eu/attributes/naturalperson/DateOfBirth", "FriendlyName" => "DateOfBirth", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
    #   { "Name" => "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier", "FriendlyName" => "PersonIdentifier", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
    #   { "Name" => "http://eidas.europa.eu/attributes/legalperson/LegalName", "FriendlyName" => "LegalName", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"},
    #   { "Name" => "http://eidas.europa.eu/attributes/legalperson/LegalPersonIdentifier", "FriendlyName" => "LegalPersonIdentifier", "NameFormat" => "urn:oasis:names:tc:SAML:2.0:attrname-format:uri", "isRequired" => "true"}
    # ]
    attrs
  end
end