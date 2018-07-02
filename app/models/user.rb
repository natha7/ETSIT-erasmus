class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :student_application_form
  accepts_nested_attributes_for :student_application_form
  
  has_attached_file :motivation_letter
  has_attached_file :curriculum_vitae
  has_attached_file :transcript_of_records
  has_attached_file :learning_agreement
  has_attached_file :valid_insurance_policy
  has_attached_file :photo
  has_attached_file :ni_passport


  before_create :create_student_application_form

  validates_attachment_content_type :motivation_letter, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :curriculum_vitae, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :transcript_of_records, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :learning_agreement, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :valid_insurance_policy, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :photo, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :ni_passport, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]

  def status
    stf = self.student_application_form
    [
      self.motivation_letter, 
      self.curriculum_vitae, 
      self.transcript_of_records, 
      self.learning_agreement,
      stf.inst_sending_name,
      stf.inst_adress,
      stf.school_family_dpt,
      stf.erasmus_code,
      stf.dept_coordinator,
      stf.contact_person,
      stf.inst_telephone,
      stf.inst_email,
      stf.academic_year,
      stf.programme,
      stf.field_of_study,
      stf.project_work,
      stf.under_grad_courses,
      stf.graduate_courses,
      stf.mother_tongue,
      stf.language_instruction,
      stf.current_diploma_degree,
      stf.year_attended,
      stf.specialization_area,
      stf.already_study_abroad,
      stf.where_study_abroad,
      stf.where_institution_abroad
    ].uniq.all?{|x| !x.nil?} ? "Finished" : "Not Finished"
  end

  def percentage
    return "0%"
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def create_student_application_form
    unless self.admin?
      build_student_application_form
      true
    end
  end

  
end
