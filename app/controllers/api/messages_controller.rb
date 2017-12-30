class Api::MessagesController < ApiController
  def create
    form = EncryptedMessage::CreateWithPasswordForm.new(
      decrypted_content: params[:decrypted_content],
      password:          params[:password]
    )

    operation = EncryptedMessage::Create::FromCreateWithPasswordFormOperation.new(form: form)
    response  = operation.call

    response.ok do |encrypted_message|
      render json: {
        curl: "curl -X POST -d password=ENTER_YOUR_PASSWORD_HERE #{api_decrypted_message_url(uuid: encrypted_message.uuid)}",
        uuid: encrypted_message.uuid
      }
    end.error do
      render json: { error: form.errors.full_messages }, status: 422
    end
  end

  def show_decrypted
    operation = EncryptedMessage::DecryptWithPasswordAndDestroyOperation.new(
      encrypted_message_uuid: params[:uuid],
      password:               params[:password]
    )
    response  = operation.call

    response.ok do |decrypted_content|
      render json: { decrypted_content: decrypted_content }
    end.error(404) do
      head 404
    end.error do |value, messages|
      render json: { error: messages }, status: 422
    end
  end
end
