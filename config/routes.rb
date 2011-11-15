FinancialControl::Application.routes.draw do
  root :to => 'pages#index'
  match 'licence' => 'pages#licence'

  devise_for :users, :controllers => { :registrations => 'users', :sessions => 'sessions' } do
    get 'users/sign_out' => 'sessions#destroy', :as => :destroy_user_session
  end

  resources :users, :except => [:destroy]
  resources :groups do
    member do
      post :add_user
    end
  end
end
