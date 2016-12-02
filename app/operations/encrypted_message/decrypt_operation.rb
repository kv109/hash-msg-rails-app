class EncryptedMessage::DecryptOperation
  attr_reader :encrypted_message_uuid, :password

  include Wisper::Publisher

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    if encrypted_message.nil?
      return broadcast(:not_found, encrypted_message_uuid)
    end

    begin
      content = decrypted_content
    rescue OpenSSL::Cipher::CipherError => e
      return broadcast(:error, [e.message])
    end

    return broadcast(:ok, content)
  end

  private

  def decrypted_content
    @decrypted_content ||=
      encrypted_message.decrypted_content(password)
  end

  def encrypted_message
    @encrypted_message ||=
      EncryptedMessage.find(encrypted_message_uuid)
  end
end

