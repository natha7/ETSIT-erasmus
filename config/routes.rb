Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get "digital_certificate", to: "user#digital_certificate"
  post "digital_certificate", to: "user#create_user"
  get "token_registration", to: "user#token_registration"
  post "token_registration", to: "user#create_user"
  get 'user_dashboard', to: "user#user_dashboard"
  get 'admin_dashboard', to: "user#admin_dashboard"
end
