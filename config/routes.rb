Rails.application.routes.draw do
  resources :posts, only: [:index, :show]

  namespace :admin do
    resources :pages, only: [:index, :edit, :update]
    resources :posts, except: [:show]
  end

  root 'posts#index'
end
