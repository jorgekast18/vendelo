Rails.application.routes.draw do
  resources :categories, except: :show
  resources :products, path: '/'

  namespace :authentication, path: '', as: '' do
    resources :users, only: [:create, :new]
    resources :sessions, only: [:create, :new]
  end
end
