class WelcomeController < ApplicationController
  def index
    encrypted_message_create_form = EncryptedMessage::CreateForm.new
    render :index,
           locals: { encrypted_message_create_form: encrypted_message_create_form }
  end
end
