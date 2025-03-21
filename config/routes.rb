Rails.application.routes.draw do
  resources :categories, only: [ :new, :create ]
  post "tinymce_assets", to: "tinymce_assets#create"
  devise_for :users
  resources :users, only: [ :show, :edit, :update ] do
    member do
      post "follow", to: "follows#create"
      delete "unfollow", to: "follows#destroy"
    end
  end

  resources :posts do
    resources :likes, only: [ :create ]
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  get "/tags/find_or_create", to: "tags#find_or_create"
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
