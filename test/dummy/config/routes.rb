Rails.application.routes.draw do

  mount RemotePartial::Engine => "/remote_partial"
end
