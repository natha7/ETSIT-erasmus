class ProjectSettings < ActiveRecord::Base
  #https://stackoverflow.com/questions/399447/how-to-implement-a-singleton-model
  before_create :confirm_singularity

  def self.instance
    self.first_or_create!
  end

  private

  def confirm_singularity
    raise Exception.new("There can be only one.") if ProjectSettings.count > 0
  end

end