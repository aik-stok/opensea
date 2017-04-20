Rails.application.routes.draw do
  namespace :api do
    get :closest, to: "positions#closest"
  end
end
