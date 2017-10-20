Rails.application.routes.draw do
  root to: 'welcome#index'

  get 'messages/new' => 'messages#new'
  post 'messages' => 'messages#create', as: :messages
  get 'messages/:uuid/encrypted/' => 'messages#show_encrypted', as: :encrypted_message
  post 'messages/:uuid/decrypted/' => 'messages#show_decrypted', as: :decrypted_message
end
