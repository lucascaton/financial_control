FinancialControl::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users' }
  resources :users

  # root :to => 'welcome#index'
end
