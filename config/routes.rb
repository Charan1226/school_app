Rails.application.routes.draw do
  resources :courses do
    member do
      post 'apply_batches'
    end
  end
  devise_for :users
  resources :batches do
    member do
      post 'add_students'
    end
  end
  resources :schools do
    member do
      post 'add_school_admins'
    end
  end
  root to: 'passthrough#index'
end
