Rails.application.routes.draw do

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  # get  'user/sign_up', to: 'devise/registrations#new'

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

    #user route

    resources :users do
      member do
        patch :update_role
        patch :update_password # Ajout de la route pour mettre à jour le mot de passe
      end
    end
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

    resources :folders

    resources :documents

    get 'public/category/:id/products', to: 'home#products_by_category'
    get 'public/all_products', to: 'home#all_products'
    get 'public/all_categories', to: 'home#all_categories'
    get 'public/all_shops', to: 'home#all_shops' # Ajout de la route pour lister toutes les boutiques
    get 'public/shops/:shop_id/salons', to: 'home#salons_by_shop' # Ajout de la route pour récupérer les salons liés à une boutique
    resources :shops, only: [:index, :create, :update, :destroy, :stock_summary] do
      get 'stock_summary', on: :member
      resources :products, only: [:index, :create, :update, :destroy]
      resources :sales, only: [:index, :create, :update, :destroy, :show] do
        member do
          get 'download_invoice' # Ajout de la route pour télécharger la facture
        end
      end
      resources :categories, only: [:index, :create, :update, :destroy]
      resources :salons do
        resources :services
        resources :availabilities, only: [:index] # Ajout de la route pour récupérer les dispos d'un salon spécifique
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
      end
    end
    resources :reservations, only: [:create, :update, :show]
    resources :salons do
      resources :availabilities, only: [:create]
    end
    resources :availabilities, only: [:index, :destroy]
    resources :personnels, only: [:index, :show, :create, :update, :destroy]
    resources :subscription_types, only: [:index, :create, :update, :destroy] do
      member do
        post 'subsrciption_by_client' # Ajout de la route pour souscription d un client
        get 'clients', to: 'subscriptions#clients_by_subscription_type' # Ajout de la route pour récupérer les clients souscrits à un type d'abonnement
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
        get 'deleted_clients' # Ajout de la route pour récupérer les clients marqués comme supprimés
      end
    end
  end

end
