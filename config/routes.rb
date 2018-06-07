Rails.application.routes.draw do
  get 'home/welcome'
  get 'home/new_opportunity', as: 'new_opportunity'
  
  resources :employers, shallow: true do
    resources :locations
    resources :opportunities
  end
  
  resources :opportunities, only: [:index]

  resources :fellow_opportunities
  resources :opportunity_stages
  resources :employment_statuses
  resources :coaches
  resources :interests
  resources :industries
  resources :cohort_fellows
  resources :cohorts
  resources :courses
  resources :sites
  resources :contacts
  resources :fellows
  
  root to: "home#welcome"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
