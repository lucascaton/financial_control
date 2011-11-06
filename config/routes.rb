FinancialControl::Application.routes.draw do
  root :to => 'pages#index'
  match 'licence' => 'pages#licence'

  devise_for :users, :controllers => { :registrations => 'users', :sessions => 'sessions' }
  resources :users, :except => [:destroy]
  resources :groups
end
