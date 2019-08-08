Rails.application.routes.draw do
  post 'login' => 'user_token#create'
  
  namespace :convertions do
    resources :public, only: [:index, :create]
    resources :private, only: [:index, :create]
  end
end
