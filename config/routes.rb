Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "home#index"
  get '/home', to: 'home#index'
  get '/main', to: 'main#index', as: 'main'
  post '/main/messed_up', to: 'main#messed_up', as: 'messed_up'
  post '/main/undo', to: 'main#undo', as: 'undo'
  post '/main/reset', to: 'main#reset', as: 'reset'

  post '/user', to: 'user#create'
  post '/login', to: "session#create"
  delete '/logout', to: "session#destroy", as: "logout"
  :sessions
end
