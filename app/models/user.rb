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

  before_create :create_student_application_form

  validates_attachment_content_type :motivation_letter, :content_type => ["application/pdf", "application/doc", "application/docx",
    "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :curriculum_vitae, :content_type => ["application/pdf", "application/doc", "application/docx",
    "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :transcript_of_records, :content_type => ["application/pdf", "application/doc", "application/docx",
    "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :learning_agreement, :content_type => ["application/pdf", "application/doc", "application/docx",
    "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]


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
