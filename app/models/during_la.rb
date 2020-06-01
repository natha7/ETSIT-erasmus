class DuringLA < ApplicationRecord
    belongs_to :user
    
    has_many :during_la_subject

    has_attached_file :during_la_signed_student, :url=> "/erasmus/attachment/dm_student/:id/:basename.:extension"
    has_attached_file :during_la_signed_host, :url=> "/erasmus/attachment/dm_host/:id/:basename.:extension"
    has_attached_file :during_la_signed_all, :url=> "/erasmus/attachment/dm_all/:id/:basename.:extension"
    has_attached_file :payment_letter, :url=> "/erasmus/attachment/dm/:id/:basename.:extension"
    validates_attachment_content_type :during_la_signed_student, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :during_la_signed_host, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :during_la_signed_all, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_content_type :payment_letter, :content_type => ["application/pdf", "application/doc", "application/docx", "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"]
    validates_attachment_size :during_la_signed_student, :less_than => 4.megabytes
    validates_attachment_size :during_la_signed_host, :less_than => 4.megabytes
    validates_attachment_size :during_la_signed_all, :less_than => 4.megabytes
    validates_attachment_size :payment_letter, :less_than => 4.megabytes

    after_validation :clean_paperclip_errors

    def clean_paperclip_errors
        errors.delete(:during_la_signed_student)
        errors.delete(:during_la_signed_host)
        errors.delete(:during_la_signed_all)
        errors.delete(:payment_letter)
      end
end