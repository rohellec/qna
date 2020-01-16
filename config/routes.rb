Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, only: %i[index create update destroy]
  end
end
