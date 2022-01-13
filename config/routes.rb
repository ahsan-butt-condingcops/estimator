Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users

  resources :cost_estimates do
    collection do
      get :populate_terminologies
    end
  end

  resources :visit_templates
  resources :terminologies

  get 'pages/home'
  get 'dashboard/Index'
end
