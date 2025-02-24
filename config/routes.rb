Rails.application.routes.draw do
  root "homepage#index"
  
  resource :session, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users
  get 'signup', to: 'users#new'
  resources :learning_resources
  resources :courses do
    resources :course_items
  end

  resources :study_sets do
    member do
      post :add_course
      delete :remove_course
      get :select_courses
    end
    
    resources :learning_plans, only: [:new, :create, :edit, :update, :destroy]
    get 'study', on: :member
  end

  # Study progress tracking
  resources :study_progresses, only: [:update] do
    post :mark_as_studied, on: :member
  end
end
