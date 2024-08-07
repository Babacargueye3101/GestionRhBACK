Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  namespace :api do
    devise_for :users, controllers: { sessions: 'api/sessions' }

    #route for Compagny
    resources :companies, only: [:create, :update, :destroy, :show, :index]
  end

end
