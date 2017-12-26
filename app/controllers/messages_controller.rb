class MessagesController < ApplicationController
  def new
    form = EncryptedMessage::CreateWithPasswordForm.new
    render :new, locals: { form: form }
  end

  def create
    form      = EncryptedMessage::CreateWithPasswordForm.new(create_params)
    operation = EncryptedMessage::Create::FromCreateWithPasswordFormOperation.new(form: form)
    response  = operation.call

    response.ok do |encrypted_message|
      redirect_to share_message_path(encrypted_message.uuid), notice: 'Message successfully saved'
    end.error do
      render :new, locals: { form: form }
    end
  end

  def share
    operation = EncryptedMessage::FindOperation.new(uuid: uuid_param)
    response  = operation.call

    response.ok do |encrypted_message|
      render :share,
             locals: {
               encrypted_message: encrypted_message,
               uuid:              uuid_param
             }
    end.error(404) do
      render :not_found
    end
  end

  def show_encrypted
    operation = EncryptedMessage::FindOperation.new(uuid: uuid_param)
    response  = operation.call

    response.ok do |encrypted_message|
      render :show_encrypted, locals: { encrypted_message: encrypted_message }
    end.error(404) do
      render :not_found
    end
  end

  def show_decrypted
    operation = EncryptedMessage::DecryptAndDestroyOperation.new(
      encrypted_message_uuid: params.fetch(:uuid),
      password:               encrypted_message_params.fetch(:password)
    )
    response  = operation.call

    response.ok do |decrypted_content|
      @decrypted_content = decrypted_content
    end.error(404) do
      render :not_found
    end.error do |value, messages|
      render :error, locals: { error: messages.join(', ') }
    end
  end

  private

  def create_params
    params.require(:encrypted_message_create_with_password_form).permit(:decrypted_content, :password, :question)
  end

  def encrypted_message_params
    params.require(:encrypted_message).permit(:password)
  end

  def uuid_param
    params.require(:uuid)
  end
end
