Rails.application.routes.draw do
  resources :items, only: [:index, :destroy]
  resources :categories, only: [:show], param: :slug

  scope module: "user" do
    resources :users,
              only: [:new, :create, :show, :edit, :update],
              param: :slug do
      resources :jobs, only: [:show, :new, :update, :edit] do
        resources :comments, only: [:new, :create]
      end
    end
    resources :bids, only: [:create]
  end

  namespace :admin do
    get "/dashboard", to: "users#dashboard"
    resources :items
    resources :orders, only: [:index, :update]
  end

  resources :artists, only: [:index, :show], param: :slug

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get "/dashboard", to: "user/users#dashboard"
  get "/sign_up", to: "user/users#new"

  root "home#index"
end
