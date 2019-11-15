Rails.application.routes.draw do
  root :to => 'json_data#index'

  get 'json_data/index'
  post 'json_data/search'
end
