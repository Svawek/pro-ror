Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    delete '/delete_file/:file_id', to: 'questions#delete_file', as: :delete_file, on: :member

    resources :answers, shallow: true, only: %i[new create destroy update] do
      member do
        patch :select_best
        delete '/delete_file/:file_id', to: 'answers#delete_file', as: :delete_file
      end
    end
  end

  root to: 'questions#index'
end
