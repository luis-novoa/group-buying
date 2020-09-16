Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  resources :users do
    member { get :confirm_email }
  end
  resources :users, only: %i[show index edit update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :orders, only: %i[index]
  resources :partners, only: %i[index]
  resources :purchases, only: %i[index show]
  resources :volunteer_infos, only: %i[new create]
  get '/cart' => 'orders#index', paid: false
  get '/about' => 'static_pages#show', page: 'about'
  root 'purchases#index'
end
