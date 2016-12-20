class EncryptedMessage::DecryptOperation
  attr_reader :encrypted_message_uuid, :password

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    if encrypted_message.nil?
      return Coman::Response.error(code: 404, result: encrypted_message_uuid)
    end

    content = decrypted_content
    if content.nil?
      return Coman::Response.error(messages: ['wrong password'])
    else
      Coman::Response.ok(result: content)
    end
  end

  private

  def decrypted_content
    Cipher.decrypt(encrypted_content: encrypted_message.encrypted_content, password: password)
  end

  def encrypted_message
    EncryptedMessage.find(encrypted_message_uuid)
  end
end
