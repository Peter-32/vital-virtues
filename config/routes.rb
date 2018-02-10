Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "main#index"
  get '/home', to: 'home#index'
  get '/main', to: 'main#index', as: 'main'
  post '/main/messed_up', to: 'main#messed_up', as: 'messed_up'
  post '/main/undo', to: 'main#undo', as: 'undo'
  post '/main/reset', to: 'main#reset', as: 'reset'
end
