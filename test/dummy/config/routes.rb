Rails.application.routes.draw do

  resources :demos, only: [:index, :show]

  resources :samples, only: [:index, :show]

  mount RemotePartial::Engine => "/remote_partial"
end
