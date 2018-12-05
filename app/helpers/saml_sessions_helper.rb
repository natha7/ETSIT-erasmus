module SamlSessionsHelper

  def generate_metadata

  end
  def saml_attrs_to_model_attrs
  	{
  		"person_identifier" => "PersonIdentifier",
  		"family_name" => "FamilyName",
  		"first_name" => "FirstName",
  		"birth_date" => "DateOfBirth"
  	}

  end
end