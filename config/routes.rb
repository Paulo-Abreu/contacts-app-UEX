Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations',
    passwords: 'passwords'
  }
  
  resources :contacts, only: [:index, :new, :create, :destroy, :edit, :update, :show]
  root "home#index"

  get '*path', to: 'home#index', constraints: ->(request){ request.format.html? }
  get '*path', to: 'contacts#index', constraints: ->(request){ request.format.html? }
end
