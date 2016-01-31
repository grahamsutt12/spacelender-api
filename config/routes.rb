Rails.application.routes.draw do
  
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, :except => [:new, :edit] do
        member do
          get 'confirm_email'
          get 'reservations/pending' => 'reservations#pending'
        end

        resources :messages, :except => [:new, :edit]
        resources :images, :only => [:update, :destroy]
        resources :reports, :only => [:create, :show]
        resources :cards, :only => [:index, :show, :create, :destroy]
      end

      resources :listings, :except => [:new, :edit] do
        collection do
          get 'recent'
        end

        resources :reservations, :only => [:index, :show, :create, :destroy] do
          resources :payments, :only => [:create] do
            member do
              get 'refund'
            end
          end
        end

        resources :images, :only => [:index, :show, :update, :destroy]
      end

      resources :sessions, :only => [:create, :destroy]

      # Get current user's reservations
      get 'reservations' => 'users#reservations'
    end
  end

end
