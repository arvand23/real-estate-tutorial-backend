Rails.application.routes.draw do

  get '/houses/own', to: 'houses#own'
  resources :houses

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations',
  }
  get "up" => "rails/health#show", as: :rails_health_check

end
