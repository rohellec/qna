Rails.application.routes.draw do
  root "questions#index"

  devise_for :users
  devise_scope :user do
    get "sign_up", to: "devise/registrations#new"
  end

  resources :questions, shallow: true do
    resources :answers, only: %i[index create update destroy]
  end
end
