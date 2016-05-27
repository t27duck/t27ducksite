Rails.application.routes.draw do
  resources :posts, only: [:index, :show]

  namespace :admin do
    resources :posts, except: [:show]
  end
end
