Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users, :except => [:new, :edit] do
        member do
          get 'confirm_email'
        end

        resources :messages, :except => [:new, :edit]
        resources :images, :only => [:update, :destroy]
        resources :reports, :only => [:create, :show]
      end

      resources :listings, :except => [:new, :edit] do
        resources :reservations, :only => [:show, :create, :destroy] do
          resources :payments, :only => [:create] do
            member do
              get 'refund'
            end
          end
        end

        resources :images, :only => [:index, :show, :update, :destroy]
      end

      resources :sessions, :only => [:create, :destroy]
    end
  end

end
