Rails.application.routes.draw do

  resources :samples, only: [:index, :show]

  mount RemotePartial::Engine => "/remote_partial"
end
