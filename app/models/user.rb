class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :student_application_form, :dependent => :destroy

  has_attached_file :motivation_letter
  has_attached_file :curriculum_vitae
  has_attached_file :transcript_of_records
  has_attached_file :learning_agreement


  def percentage
    return "0%"
  end

  private

  def set_default_role
    self.role ||= :user
  end


  
end
