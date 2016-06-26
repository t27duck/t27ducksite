Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]

  resources :posts, only: [:index, :show]

  namespace :admin do
    resources :pages, only: [:index, :edit, :update] do
      collection do
        post :preview
      end
    end
    resources :posts, except: [:show] do
      collection do
        post :preview
      end
    end
  end

  get '/about', to: 'pages#show', id: 'about', as: :about

  root 'home#index'
end
