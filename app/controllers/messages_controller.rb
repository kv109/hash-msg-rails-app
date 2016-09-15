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
    encrypted_message = EncryptedMessage.find_and_destroy(params.fetch(:uuid))
    if encrypted_message
      @decrypted_content = encrypted_message && encrypted_message.decrypted_content(encrypted_message_params.fetch(:password))
    end
  rescue OpenSSL::Cipher::CipherError => e
    render plain: 'Could not decrypt message (wrong password?)'
  end

  private

  def create_params
    params.require(:encrypted_message_create_form).permit(:decrypted_content, :password, :question)
  end

  def encrypted_message_params
    params.require(:encrypted_message).permit(:password)
  end
end
