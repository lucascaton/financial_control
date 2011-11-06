FinancialControl::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users' }
  resources :users, :except => [:destroy]

  # root :to => 'welcome#index'
end
