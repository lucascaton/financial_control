FinancialControl::Application.routes.draw do
  root to: 'pages#index'
  match 'licence' => 'pages#licence'

  resources :entries, only: [:show, :create, :update]

  resources :groups, except: [:destroy] do
    member do
      post :add_user, :as => :add_user_to
      delete :remove_user, :as => :remove_user_from
      get :time_frames
      post :add_time_frame, :as => :add_time_frame_to
      delete :remove_time_frame, :as => :remove_time_frame_from
    end
  end

  resources :time_frames, :only => [:show] do
    member do
      get :entries
    end
  end

  devise_for :users, controllers: {
    registrations: 'users',
    sessions: 'sessions'
  }

  devise_scope :user do
    get 'users/sign_out' => 'sessions#destroy', as: :destroy_user_session
  end

  resources :users, :except => [:destroy, :show]
end
