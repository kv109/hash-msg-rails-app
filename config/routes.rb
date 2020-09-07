Rails.application.routes.draw do
=begin
  if Rails.env.production?
    constraints(:host => /^(?!www\.noteburn\.org)/i) do
      match "/(*path)" => redirect {
        |params, req| "https://www.noteburn.org/#{params[:path]}"
      },  via: [:get, :post]
    end
  end
=end

  namespace :api, defaults: { format: :json }, path: '/api' do
    post 'messages' => 'messages#create'
    get 'messages/:uuid/:token' => 'messages#show_decrypted'
    post 'messages/:uuid/' => 'messages#show_decrypted'
  end

  root to: 'welcome#index'

  get 'messages/new' => 'messages#new', as: :new_message
  post 'messages' => 'messages#create', as: :messages
  get 'messages/:uuid/' => 'messages#show_encrypted', as: :encrypted_message
  post 'messages/:uuid/' => 'messages#show_decrypted', as: :decrypted_message
  get 'messages/:uuid/share/' => 'messages#share', as: :share_message
end
