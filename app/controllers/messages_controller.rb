class MessagesController < ApplicationController
  def new
    @encrypted_message_create_form = EncryptedMessage::CreateForm.new
  end

  def create
    @encrypted_message_create_form = EncryptedMessage::CreateForm.new(create_params)
    operation = EncryptedMessage::Create::FromCreateFormOperation.new(form: @encrypted_message_create_form)
    response = operation.call

    response.ok do |encrypted_message|
      redirect_to encrypted_message_path(encrypted_message.uuid)
    end.error do
      render :new
    end
  end

  def show_encrypted
    @encrypted_message = EncryptedMessage.find(params.fetch(:uuid))
  end

  def show_decrypted
    operation = EncryptedMessage::DecryptAndDestroyOperation.new(
      encrypted_message_uuid: params.fetch(:uuid),
      password:               encrypted_message_params.fetch(:password)
    )
    response = operation.call

    response.ok do |decrypted_content|
      @decrypted_content = decrypted_content
    end.error do |value, messages|
      @error_message = messages.join(', ')
    end
  end

  private

  def create_params
    params.require(:encrypted_message_create_form).permit(:decrypted_content, :password, :question)
  end

  def encrypted_message_params
    params.require(:encrypted_message).permit(:password)
  end
end
