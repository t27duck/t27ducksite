# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", "as" => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "serviceWorker", to: "rails/pwa#service_worker", as: :pwa_service_worker_alt

  resource :session, only: [:new, :create, :destroy]

  resources :posts, only: [:index, :show]
  get "/posts/tag/:tag", to: "posts#tag", as: :tag_posts
  resources :talks, only: [:index]

  get "/admin", to: "admin/posts#index"
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

  get "/about", to: "pages#show", id: "about", as: :about

  root "home#index"
end
