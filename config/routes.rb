Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    member { get :confirm_email }
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :purchases, only: %i[index show]
  resources :volunteer_infos, only: %i[new create]
  root 'purchases#index'
end
