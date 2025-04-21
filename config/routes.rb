Rails.application.routes.draw do
  resources :categories, only: [ :new, :create, :show ]
  post "tinymce_assets", to: "tinymce_assets#create"
  devise_for :users
  resources :users, only: [ :show, :edit, :update ] do
    member do
      post "follow", to: "follows#create"
      delete "unfollow", to: "follows#destroy"
    end
  end

  resources :posts do
    collection do
      get "tagged", to: "posts#tagged", as: "tagged"
      get :search
    end
    resources :likes, only: [ :create ]
    resources :comments, only: [ :create, :edit, :update, :destroy ]
    resources :bookmarks, only: [ :create, :destroy ]
  end

  get "/tags/find_or_create", to: "tags#find_or_create"
  get "/tags/trending", to: "tags#trending", as: "trending_tags"
  get "up" => "rails/health#show", as: :rails_health_check
  get "/popular", to: "posts#popular", as: "popular_posts"
  get "/latest", to: "posts#latest", as: "latest_posts"
  get "/search", to: "search#index", as: "search"
  get "/bookmarks", to: "bookmarks#index", as: "bookmarks"

  resources :notifications, only: [ :index ] do
    member do
      patch :mark_as_read
    end
  end

  mount ActionCable.server => "/cable"

  root "posts#index"
end
