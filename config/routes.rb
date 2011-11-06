FinancialControl::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users', :sessions => 'sessions' }
  resources :users, :except => [:destroy]

  root :to => 'pages#index'

  match 'licence' => 'pages#licence'
end
