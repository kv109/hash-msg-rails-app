class Api::MessagesController < ApiController
  def create
    operation = create_params_to_operation
    response  = operation.call

    response.ok do |encrypted_message_data|
      render json: encrypted_message_data
    end.error do |_value, messages|
      render json: { error: messages }, status: 422
    end
  end

  def show_decrypted
    operation = EncryptedMessage::DecryptWithPasswordAndDestroyOperation.new(
      encrypted_message_uuid: params[:uuid],
      password:               params[:password] || params[:token]
    )
    response  = operation.call

    response.ok do |decrypted_content|
      if params[:output] == 'raw'
        render plain: decrypted_content
      else
        render json: { decrypted_content: decrypted_content }
      end
    end.error(404) do
      head 404
    end.error do |_value, messages|
      render json: { error: messages }, status: 422
    end
  end

  private

  def create_params_to_operation
    if params[:password]
      form = EncryptedMessage::CreateWithPasswordForm.new(
        decrypted_content: params[:decrypted_content],
        password:          params[:password]
      )

      EncryptedMessage::Create::FromCreateWithPasswordFormOperation.new(form: form)
    else
      form = EncryptedMessage::CreateWithTokenForm.new(
        decrypted_content: params[:decrypted_content]
      )

      EncryptedMessage::Create::FromCreateWithTokenFormOperation.new(form: form)
    end
  end
end
