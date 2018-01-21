Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  resources :posts, only: %i[index show]
  get '/posts/tag/:tag', to: 'posts#tag', as: :tag_posts
  resources :talks, only: [:index]

  namespace :admin do
    resources :pages, only: %i[index edit update] do
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
