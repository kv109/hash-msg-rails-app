class Api::MessagesController < ActionController::API
  def create
    form = EncryptedMessage::CreateWithPasswordForm.new(
      decrypted_content: params[:decrypted_content],
      password:          params[:password]
    )

    operation = EncryptedMessage::Create::FromCreateWithPasswordFormOperation.new(form: form)
    response  = operation.call

    response.ok do |encrypted_message|
      render json: { curl: "curl -X POST -d password=ENTER_YOUR_PASSWORD_HERE #{api_decrypted_message_url(uuid: encrypted_message.uuid)}" }
    end.error do
      render json: { error: form.errors }, status: 422
    end
  end
end
