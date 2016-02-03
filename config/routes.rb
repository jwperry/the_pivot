Rails.application.routes.draw do
  resources :items, only: [:index, :destroy]
  resources :categories, only: [:show], param: :slug

  resources :users,
            only: [:new, :create, :show, :edit, :update],
            param: :slug do
    resources :jobs, only: [:show]
  end
  resources :bids, only: [:create]

  namespace :admin do
    get "/dashboard", to: "users#show"
    resources :items
    resources :orders, only: [:index, :update]
  end

  resources :artists, only: [:index, :show], param: :slug

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "/dashboard", to: "users#show"
  get "/sign_up", to: "users#new"

  root "home#index"
end
