Rails.application.routes.draw do  
  resources :users, defaults: {format: :json} do
    resources :messages, defaults: {format: :json}
  end

  match '', to: 'users#create', via: [:post], defaults: {format: :json}
  match '', to: 'users#index', via: [:get], defaults: {format: :json}

  match ':id', to: 'users#show', via: [:get], defaults: {format: :json}
  match ':id/delete', to: 'users#destroy', via: [:get], defaults: {format: :json}

  match ':id/pubkey', to: 'users#pubkey', via: [:get], defaults: {format: :json}

  match 'message', to: 'messages#create', via: [:post], defaults: {format: :json}
  match ':user_id/message', to: 'messages#index', via: [:get], defaults: {format: :json}

end
