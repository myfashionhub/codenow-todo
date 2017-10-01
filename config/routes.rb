Rails.application.routes.draw do
  root 'items#index'
  get '/items'        => 'items#index'
  post '/items'       => 'items#create'
  get '/items/:id'    => 'items#show'
  post '/items/:id'   => 'items#update'
  post '/items/:id/delete' => 'items#destroy'
end
