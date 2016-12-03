class EncryptedMessage::DecryptAndDestroyOperation
  attr_reader :encrypted_message_uuid, :password

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    result = decrypt_operation.call
    if result.ok?
      EncryptedMessage.destroy(encrypted_message_uuid)
      return result
    else
      return result
    end
  end

  private

  def decrypt_operation
    EncryptedMessage::DecryptOperation.new(
      encrypted_message_uuid: encrypted_message_uuid,
      password:               password
    )
  end
end
