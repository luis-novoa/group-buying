Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }
  resources :users do
    member { get :confirm_email }
  end
  resources :users, only: %i[show index edit update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :orders, only: %i[create update destroy index]
  resources :pagseguros, only: %i[create]
  resources :pagseguro_notifications, only: %i[create]
  resources :partners, only: %i[index show create new update edit]
  resources :payments, only: %i[create show]
  resources :products
  resources :public_partners, only: %i[index]
  resources :purchases, except: %i[new destroy]
  resources :purchase_lists, only: %i[index show update]
  resources :purchase_products, expect: %i[edit]
  resources :volunteer_infos, only: %i[new create index update edit]
  get '/about' => 'static_pages#show', page: 'about'
  root 'purchase_products#index'
end
