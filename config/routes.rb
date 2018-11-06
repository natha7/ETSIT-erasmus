Rails.application.routes.draw do

  scope 'erasmus' do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    devise_for :users, skip: [:registrations, :saml_authenticatable]
    devise_scope :user do
      root to: "users/sessions#new"
      post 'sign_up', to: "registrations#create", :as => :user_registration
      scope "users", controller: 'saml_sessions' do
        post :new, path: "eidas/sign_in", as: :new_user_sso_session
        post :create, path: "eidas/auth", as: :eidas_endpoint #:user_sso_session
        get :eidas, path: "eidas/eidas", as: :eidas_session
        get :destroy, path: "sign_out", as: :destroy_user_sso_session
        get :metadata, path: "eidas/metadata", as: :metadata_user_sso_session
        match :idp_sign_out, path: "eidas/idp_sign_out", via: [:get, :post]
      end
    end


    get "digital_certificate", to: "user#digital_certificate"
    post "create_user", to: "user#create_user"
    get "token_registration", to: "user#token_registration"
    post "token_registration", to: "user#create_user"
    get 'user_dashboard', to: "user#user_dashboard"
    get 'review_dashboard/:user', to: "user#review_dashboard"
    get 'admin_dashboard', to: "user#admin_dashboard"
    get 'massive_email', to: "user#massive_email"
    get 'download_all_files/:user', to: "user#download_all_files"
    post 'create_nominee', to: "nominated_user#create_nominee"
    post 'create_nominee_multiple', to: "nominated_user#create_nominee_multiple"
    post 'resend_email', to: "nominated_user#resend_email"
    delete 'delete_nominee', to: "nominated_user#delete_nominee"

    get 'register/:token_registration', to: "nominated_user#register"
    get 'register/:token_registration/register_with_eidas', to: "user#register_with_eidas"
    get 'register/:token_registration/register_with_email_and_password', to: "user#register_with_email_and_password"

    get 'generate_pdf', to: "student_application_form#generate_pdf"
    get 'generate_pdf/:user', to: "student_application_form#generate_pdf"
    get 'generate_acceptance_letter/:user', to: "user#generate_acceptance_letter"
    get 'generate_acceptance_letters', to: "user#generate_acceptance_letters"
    get 'generate_csv', to: "user#generate_csv"

    get 'student_application_form', to: "student_application_form#sap_page"
    post 'student_application_form', to: "student_application_form#save"
    get 'student_application_form/personal_data_step', to: "student_application_form#personal_data"
    get 'student_application_form/:step', to: "student_application_form#change_step"
    post 'student_application_form/personal_data', to: "user#update_personal_data"

    get 'review_student_application_form/:user/personal_data_step', to:"student_application_form#review_personal_data_step"
    get 'review_student_application_form/:user/:step', to:"student_application_form#review_step"

    post 'user/finish_application_form', to: "user#finish_app_form"
    post 'user/file_upload', to: "user#file_upload"
    post 'set_user_status', to: "user#set_user_status"
    post 'user/file_upload_ajax', to: "user#file_upload_ajax"
    post 'user/submit_la', to: "user#submit_la"
    post 'update_settings', to: "user#update_settings"
    delete 'user/file_delete', to: "user#file_delete"
    get "*erasmus/", to: "home#filter_double_erasmus"
  end
end
