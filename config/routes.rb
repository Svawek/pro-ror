Rails.application.routes.draw do
  devise_for :users

  scope :users do
    resources :awards, shallow: true, only: %i[index]
  end

  resources :votes, shallow: true, only: %i[destroy]

  resources :attachments, shallow: true, only: %i[destroy]
  resources :links, shallow: true, only: %i[destroy]

  resources :questions do
    member do 
      post :vote
    end
    resources :answers, shallow: true, only: %i[new create destroy update] do
      member do
        patch :select_best
        post :vote
      end
    end
  end

  root to: 'questions#index'
end
