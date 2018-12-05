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
end