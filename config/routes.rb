Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', sessions: 'sessions', passwords: 'passwords' }
  # devise_for :users
  get 'home/welcome'
  get 'home/new_opportunity', as: 'new_opportunity'
  
  resources :employers, shallow: true do
    resources :locations
    resources :opportunities do
      resources :tasks
      resources :candidates, only: [:index, :create, :update, :destroy]
    end
  end
  
  resources :opportunities, only: [:index]

  resources :sites, shallow: true do
    resources :courses, except: [:index]
  end

  resources :fellows do
    collection do
      get :upload
      post :upload
    end
  end

  resources :fellow_opportunities
  resources :opportunity_stages
  resources :employment_statuses
  resources :coaches

  resources :interests do
    collection do
      get :list
    end
  end

  resources :industries do
    collection do
      get :list
    end
  end

  resources :metros, only: [:index] do
    collection do
      get :list
    end
  end
  resources :cohort_fellows
  resources :cohorts
  resources :contacts
  
  root to: "home#welcome"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
