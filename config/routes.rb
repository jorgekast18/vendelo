Rails.application.routes.draw do
  resources :categories, except: :show
  resources :products, path: '/'

  # Defines the root path route ("/")
  # root "posts#index"
end
