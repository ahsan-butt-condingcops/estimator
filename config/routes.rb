Rails.application.routes.draw do
  resources :fee_schedules
  root 'pages#home'
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :cost_estimates do
    collection do
      get :populate_terminologies
      get :populate_charges
    end
  end

  resources :visit_templates
  resources :terminologies

  get 'pages/home'
  get 'dashboard/Index'
end
