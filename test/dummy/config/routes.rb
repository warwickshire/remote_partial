Rails.application.routes.draw do

  root :to => 'demos#index'

  resources :demos, only: [:index, :show]


end
