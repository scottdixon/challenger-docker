Rails.application.routes.draw do
  root "submissions#index"
  resources :submissions
  resources :challenges
  devise_for :users
  get '/submissions/:id/test', to: 'submissions#test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
