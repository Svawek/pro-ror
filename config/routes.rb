Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :attachments, shallow: true, only: %i[destroy]
  resources :links, shallow: true, only: %i[destroy]
  resources :awards, shallow: true, only: %i[index]

  resources :questions do
    resources :answers, shallow: true, only: %i[new create destroy update] do
      member do
        patch :select_best
      end
    end
  end

  root to: 'questions#index'
end
