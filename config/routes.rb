Rails.application.routes.draw do
  post '/follow', to: 'user_follows#create'
  delete '/follow', to: 'user_follows#destroy'
end
