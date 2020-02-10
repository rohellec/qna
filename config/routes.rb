Rails.application.routes.draw do
  root "questions#index"

  devise_for :users
  devise_scope :user do
    get "sign_up",  to: "devise/registrations#new"
    get "sign_in",  to: "devise/sessions#new"
    get "sign_out", to: "devise/sessions#destroy"
  end

  resources :questions, shallow: true do
    resources :answers, only: %i[index create update destroy]
  end
end
