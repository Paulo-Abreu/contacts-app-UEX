# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations',
    passwords: 'passwords'
  }

  root "home#index"

  get '*path', to: 'home#index', constraints: ->(request){ request.format.html? }
end
