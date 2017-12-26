class WelcomeController < ApplicationController
  def index
    form = EncryptedMessage::CreateWithPasswordForm.new
    render :index,
           locals: { form: form }
  end
end
