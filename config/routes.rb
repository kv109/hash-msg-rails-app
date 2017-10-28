Rails.application.routes.draw do
  root to: 'welcome#index'

  get 'messages/new' => 'messages#new'
  post 'messages' => 'messages#create', as: :messages
  get 'messages/:uuid/' => 'messages#show_encrypted', as: :encrypted_message
  post 'messages/:uuid/' => 'messages#show_decrypted', as: :decrypted_message
  get 'messages/:uuid/share/' => 'messages#share', as: :share_message
end
