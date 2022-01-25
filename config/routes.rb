Rails.application.routes.draw do
  resources :fee_schedules
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :cost_estimates do
    collection do
      get :populate_terminology_fields
      get :populate_terminologies
      get :populate_charges
    end
  end

  resources :visit_templates do
    get :add_units
  end

  resources :terminologies

  get 'pages/home'
  get 'dashboard/Index'
  root 'pages#home'
end
