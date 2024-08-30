Rails.application.routes.draw do

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  get  'user/sign_up', to: 'devise/registrations#new'

  namespace :api do
    get 'announcements/index'
    get 'announcements/show'
    get 'announcements/new'
    get 'announcements/create'
    get 'announcements/edit'
    get 'announcements/update'
    get 'announcements/destroy'
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }


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

    resources :announcements


    namespace :v1 do
      resources :appointments
    end
  end

end
