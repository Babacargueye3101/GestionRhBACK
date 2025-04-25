Rails.application.routes.draw do
  # Route racine
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  # Configuration de Devise pour l'API
  devise_for :users, skip: [:sessions, :registrations]
  devise_for :users, controllers: {
    sessions: 'api/sessions'
  }, path: 'api/auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  }

  # Namespace API
  namespace :api do
    # Routes d'authentification non protégées
    post 'auth/login', to: 'sessions#create'
    post 'auth/register', to: 'sessions#register'
    delete 'auth/logout', to: 'sessions#destroy'

    # Routes protégées
    resources :users do
      member do
        patch :update_role
        patch :update_password
      end
    end

    resources :companies, only: [:create, :update, :destroy, :show, :index] do
      member do
        post :upload_logo
      end
    end

    resources :employees, only: [:index, :show, :create, :update, :destroy] do
      member do
        post :upload_document
        get :getAll
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

    resources :folders
    resources :documents

    # Routes publiques
    scope :public do
      get 'category/:id/products', to: 'home#products_by_category'
      get 'all_products', to: 'home#all_products'
      get 'all_categories', to: 'home#all_categories'
      get 'all_shops', to: 'home#all_shops'
      get 'shops/:shop_id/salons', to: 'home#salons_by_shop'
      post 'create_order', to: 'home#create_order'
      get 'products/pending', to: 'products#pending_orders'
    end

    resources :shops, only: [:index, :create, :update, :destroy] do
      get 'stock_summary', on: :member
      resources :products, only: [:index, :create, :update, :destroy]
      resources :sales, only: [:index, :create, :update, :destroy, :show] do
        member do
          get 'download_invoice'
        end
      end
      resources :categories, only: [:index, :create, :update, :destroy]
      resources :salons do
        resources :services
        resources :availabilities, only: [:index]
        resources :reservations, only: [:index]
      end
    end

    resources :stats, only: [] do
      collection do
        get 'sales_by_channel'
        get 'sales_trends'
        get 'top_sales_and_loyal_customers'
        get 'payment_usage_stats'
        get 'sales_by_employee'
        get 'all_personnel'
        get 'summary_stats'
      end
    end

    resources :time_slots, only: [:index, :create]
    resources :reservations, only: [:create, :update, :show]

    resources :salons do
      resources :availabilities, only: [:create]
    end

    resources :availabilities, only: [:index, :destroy]
    resources :personnels, only: [:index, :show, :create, :update, :destroy]

    resources :subscription_types, only: [:index, :create, :update, :destroy] do
      member do
        post 'subsrciption_by_client'
        get 'clients', to: 'subscriptions#clients_by_subscription_type'
      end
    end

    resources :subscriptions, only: [:index, :create, :update, :destroy]
    resources :channels
    resources :payment_methodes

    resources :clients do
      member do
        get 'reservations'
      end
      collection do
        get 'deleted_clients'
      end
    end

    resources :orders, only: [:index, :show, :destroy] do
      member do
        patch :update_status
      end
    end
  end
end