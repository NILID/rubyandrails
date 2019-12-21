Rails.application.routes.draw do
  mount_roboto

  resources :videos
  resources :articles do
    collection do
      get :unpublished
      get :deleted
    end
    member do
      put :publish
    end
  end
  devise_for :users

  resources :users, only: %i[show index edit update]
  root 'main#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
