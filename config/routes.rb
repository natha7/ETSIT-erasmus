Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  devise_for :users, skip: [:registrations]
  devise_scope :user do
    post 'sign_up', to: "registrations#create", :as => :user_registration
  end
  get "digital_certificate", to: "user#digital_certificate"
  post "create_user", to: "user#create_user"
  get "token_registration", to: "user#token_registration"
  post "token_registration", to: "user#create_user"
  get 'user_dashboard', to: "user#user_dashboard"
  get 'review_dashboard/:user', to: "user#review_dashboard"
  get 'admin_dashboard', to: "user#admin_dashboard"


  post 'create_nominee', to: "nominated_user#create_nominee"
  post 'resend_email', to: "nominated_user#resend_email"
  delete 'delete_nominee', to: "nominated_user#delete_nominee"

  get 'register/:token_registration', to: "nominated_user#register"
  get 'register/:token_registration/register_with_eidas', to: "user#register_with_eidas"
  get 'register/:token_registration/register_with_email_and_password', to: "user#register_with_email_and_password"

  get 'generate_pdf', to: "student_application_form#generate_pdf"
  get 'student_application_form', to: "student_application_form#sap_page"
  post 'student_application_form', to: "student_application_form#save"
  get 'student_application_form/:step', to: "student_application_form#change_step"
  get 'review_student_application_form/:user/:step', to:"student_application_form#review_step"
  post 'user/file_upload', to: "user#file_upload"
  post 'user/file_upload_ajax', to: "user#file_upload_ajax"
  delete 'user/file_delete', to: "user#file_delete"
end
