Rails.application.routes.draw do
  devise_for :users

  scope :users do
    resources :awards, shallow: true, only: %i[index]
  end

  resources :attachments, shallow: true, only: %i[destroy]
  resources :links, shallow: true, only: %i[destroy]

  resources :questions do
    resources :answers, shallow: true, only: %i[new create destroy update] do
      member do
        patch :select_best
      end
    end
  end

  root to: 'questions#index'
end
