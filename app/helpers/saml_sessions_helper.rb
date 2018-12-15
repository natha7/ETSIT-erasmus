
require 'json'
require "base64"
require 'active_support/core_ext/hash'  #from_xml 
require 'nokogiri'

module SamlSessionsHelper
  include ApplicationHelper
  requested_eidas_attrs = File.read(Rails.root + 'vendor/saml2-node/requested_attributes.json')
  parsed_eidas_attrs = {}
  begin 
    parsed_eidas_attrs = JSON.parse(requested_eidas_attrs)
  rescue
  end
  def generate_metadata

  end

  def parseXML(str)
    mod_str = ("<All>" + str + "</All>").gsub("eidas-natural:","")
    doc = Nokogiri::XML(mod_str)
    Hash.from_trusted_xml(doc.to_s)["All"]
  end

  def parseAddress(value)
    decoded = Base64.decode64(value)
    parsedXML = parseXML(decoded)
    parsedXML.map{|k,v| "#{v}"}.join(', ')
  end

  def parseEidasAttr(key,value)
    attr = {:key => key, :value => value, :sap => false}
    case key
    when "PersonIdentifier"
      attr[:key] = "person_identifier"
    when "FamilyName"
      attr[:key] = "family_name"
    when "FirstName"
      attr[:key] = "first_name"
    when "DateOfBirth"
      attr[:key] = "birth_date"
    when "PlaceOfBirth"
      attr[:key] = "born_place"
    when "CurrentAddress"
      attr[:key] = "permanent_adress"
      attr[:value] = parseAddress(value)
    when "Gender"
      attr[:key] = "sex"
    when "CurrentPhoto" # TODO save & max size
      attr[:key] = "photo"
      attr[:value] = Base64.decode64(value)
    when "Phone"
      attr[:key] = "phone_number" 
    when "Nationality"
      attr[:key] = "nationality"
      attr[:value] = country_from_code(value)
    when "CurrentLevelOfStudy"
      attr[:key] = "purpose_of_stay" # TODO ISCED Version
      if (value == 4)
        attr[:value] = ["undergraduate_courses"]
      elsif (value == 5)
        attr[:value] = ["master_courses"]
      elsif (value == 6)
        attr[:value] = ["thesis"]
      else
        attr[:value] = ["other"]
      end
      attr[:sap] = true
    when "CurrentDegree"
      attr[:key] = "current_diploma_degree"
      attr[:sap] = true
    when "Degree"
      attr[:key] = "current_diploma_degree"
      attr[:sap] = true
    when "GraduationYear"
      attr[:key] = "year_attended"
      attr[:sap] = true
    when "HomeInstitutionName"
      attr[:key] = "inst_sending_name"
      attr[:sap] = true
    when "HomeInstitutionAddress"  
      attr[:key] = "inst_adress"
      attr[:value] = parseAddress(value)
      attr[:sap] = true
    when "FieldOfStudy"
      attr[:key] = "specialization_area" 
      attr[:value] = isced_fos(value)
      attr[:sap] = true
    when "LanguageProficiency" # TODO parse XML
      attr[:key] = "unknown"
    else
      attr[:key] = "unknown"
    end
    attr
  end  

  def get_eidas_requested_attrs
    requested_attributes = REQUESTED_EIDAS_ATTRS

    array_natural = ["PersonIdentifier" , "FamilyName", "FirstName", "DateOfBirth", "PlaceOfBirth", "CurrentAddress", "Gender","CurrentPhoto", "Nationality", "Phone", "CurrentDegree", "Degree", "DegreeAwardingInstitution", "DegreeCountry", "FieldOfStudy", "GraduationYear", "LanguageCertificates", "LanguageProficiency", "HomeInstitutionAddress", "HomeInstitutionCountry", "HomeInstitutionName", "TemporaryAddress"]
    array_legal = ["LegalPersonIdentifier", "LegalName"]
    array_representative = []
    attrs = []

    array_natural.each do |attr| 
        attrVal = requested_attributes["NaturalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end

    array_legal.each do |attr| 
        attrVal = requested_attributes["LegalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end

    array_representative.each do |attr| 
        attrVal = requested_attributes["RepresentativeNaturalPerson"][attr]
        attrs.push({ "Name" => attrVal["@Name"], "FriendlyName" => attrVal["@FriendlyName"], "NameFormat" => attrVal["@NameFormat"], "isRequired" => attrVal["@isRequired"]})
    end

    attrs
  end
end