Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # devise_scope :user do
  #   # Page d'accueil pour les utilisateurs non authentifiés
  #   unauthenticated do
  #     root to: 'devise/sessions#new', as: :unauthenticated_root
  #   end

  #   # Page d'accueil pour les utilisateurs authentifiés
  #   authenticated :user do
  #     root to: 'dashboard#index', as: :authenticated_root
  #   end
  # end

  namespace :api do
    devise_for :users, controllers: { sessions: 'api/sessions' }
    #route for Compagny
    resources :companies, only: [:create, :update, :destroy, :show, :index] do
      member do
        post :upload_logo
      end
    end
    #employees route

    resources :employees, only: [:index, :show, :create, :update, :destroy] do
      member do
        post :upload_document
        get  :getAll
      end
    end

    resources :leaves, only: [:index, :show, :create, :update, :destroy] do
      member do
        put :changeStatus
      end
    end

    resources :payments, only: [:index, :show, :create, :update, :destroy], defaults: { format: :json } do
      member do
        get :getAllPayment
      end
    end
  end

end
