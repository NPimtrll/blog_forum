Rails.application.routes.draw do
  post "tinymce_assets", to: "tinymce_assets#create"
  devise_for :users
  resources :users, only: [ :show, :edit, :update ]
  resources :posts do
    resources :likes, only: [ :create ]
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end
