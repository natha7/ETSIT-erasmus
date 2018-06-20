module ApplicationHelper
	#helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def toNumeral(number)
    numeralhash = {1=>"first", 2=>"second", 3=>"third", 4=>"forth",5=>"fifth",6=>"sixth",7=>"seventh"}
    if numeralhash.has_key?number
      numeralhash[number]
    else
      "first"
    end
  end
end
