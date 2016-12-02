class MessagesController < ApplicationController
  def new
    @encrypted_message_create_form = EncryptedMessage::CreateForm.new
  end

  def create
    @encrypted_message_create_form = EncryptedMessage::CreateForm.new(create_params)
    if @encrypted_message_create_form.valid?
      @encrypted_message = EncryptedMessage::Builder.build_from_create_form(@encrypted_message_create_form)
      @encrypted_message.save
      redirect_to encrypted_message_path(@encrypted_message.uuid)
    else
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

    operation
      .on(:error) { |error_messages| @error_message = error_messages.join(', ') }
      .on(:not_found) { @decrypted_content = nil }
      .on(:ok) { |decrypted_content| @decrypted_content = decrypted_content }
      .call
  end

  private

  def create_params
    params.require(:encrypted_message_create_form).permit(:decrypted_content, :password, :question)
  end

  def encrypted_message_params
    params.require(:encrypted_message).permit(:password)
  end
end
