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
  has_attached_file :photo,
    :default_url  => '/assets/placeholder.png'
  has_attached_file :ni_passport
  has_attached_file :recommendation_letter_1
  has_attached_file :recommendation_letter_2
  has_attached_file :official_gpa
  has_attached_file :english_test_score

  before_create :create_student_application_form
  after_validation :clean_paperclip_errors

  #validations
  validates_attachment_content_type :motivation_letter, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :curriculum_vitae, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :transcript_of_records, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :learning_agreement, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :valid_insurance_policy, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :photo, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :ni_passport, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :recommendation_letter_1, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :recommendation_letter_2, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :official_gpa, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
  validates_attachment_content_type :english_test_score, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]

  validates_attachment_size :motivation_letter, :less_than => 4.megabytes
  validates_attachment_size :curriculum_vitae, :less_than => 4.megabytes
  validates_attachment_size :transcript_of_records, :less_than => 4.megabytes
  validates_attachment_size :learning_agreement, :less_than => 4.megabytes
  validates_attachment_size :valid_insurance_policy, :less_than => 4.megabytes
  validates_attachment_size :photo, :less_than => 4.megabytes
  validates_attachment_size :ni_passport, :less_than => 4.megabytes
  validates_attachment_size :recommendation_letter_1, :less_than => 4.megabytes
  validates_attachment_size :recommendation_letter_2, :less_than => 4.megabytes
  validates_attachment_size :official_gpa, :less_than => 4.megabytes
  validates_attachment_size :english_test_score, :less_than => 4.megabytes

  validates_presence_of :first_name, message: 'You must provide your first name.', if: :not_admin?
  validates_presence_of :family_name, message: 'You must provide your family name.', if: :not_admin?
  validates_presence_of :birth_date, message: 'You must provide your birth date.', if: :not_admin?
  #validates_presence_of :born_place, message: 'You must provide your born place.', if: :not_admin?
  validates_presence_of :nationality, message: 'You must provide your nationality.', if: :not_admin?
  validates_presence_of :sex, message: 'You must provide your sex.', if: :not_admin?
  validates_presence_of :permanent_adress, message: 'You must provide your permanent_adress.', if: :not_admin?
  validates_presence_of :phone_number, message: 'You must provide your phone_number.', if: :not_admin?
  

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
      stf.specialization_area
    ].uniq.all?{|x| !x.blank?} ? "Finished" : "Not Finished"
  end

  def percentage_num
   attachment_values =  [
     :motivation_letter,
     :curriculum_vitae,
     :transcript_of_records,
     :learning_agreement,
     :valid_insurance_policy,
     :photo,
     :ni_passport,
     :recommendation_letter_1,
     :recommendation_letter_2,
     :official_gpa,
     :english_test_score
   ]
   attach_value = attachment_values.map{|val| !self[val].blank? ? 1 : 0 }.reduce(0,:+) + self.student_application_form.completed_percentage_num.to_f/100
   ((attach_value.to_f * 100) /(attachment_values.length + 1)).round(2)
  end
  
  def percentage
    percentage_num.to_s + "%"
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

  def not_admin?
      role != "admin"
  end

  def clean_paperclip_errors
    errors.delete(:motivation_letter)
    errors.delete(:curriculum_vitae)
    errors.delete(:transcript_of_records)
    errors.delete(:learning_agreement)
    errors.delete(:valid_insurance_policy)
    errors.delete(:photo)
    errors.delete(:ni_passport)
    errors.delete(:recommendation_letter_1)
    errors.delete(:recommendation_letter_2)
    errors.delete(:official_gpa)
    errors.delete(:english_test_score)
  end
  
end
