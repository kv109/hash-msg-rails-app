class EncryptedMessage::DecryptOperation
  require 'aes'

  attr_reader :encrypted_message_uuid, :password

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    if encrypted_message.nil?
      return Coman::Response.error(code: 404, result: encrypted_message_uuid)
    end

    begin
      content = decrypted_content
    rescue OpenSSL::Cipher::CipherError => e
      message = e.message == 'bad decrypt' ? 'wrong password' : e.message
      return Coman::Response.error(messages: [message])
    end

    Coman::Response.ok(result: content)
  end

  private

  def decrypted_content
    key = password + Rails.application.secrets.fetch(:secret_key_base)
    AES.decrypt(encrypted_message.encrypted_content, key)
  end

  def encrypted_message
    EncryptedMessage.find(encrypted_message_uuid)
  end
end
