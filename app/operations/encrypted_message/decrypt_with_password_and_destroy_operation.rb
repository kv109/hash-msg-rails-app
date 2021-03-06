class EncryptedMessage::DecryptWithPasswordAndDestroyOperation
  attr_reader :encrypted_message_uuid, :password

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    result = decrypt_operation.call
    result.ok do
      EncryptedMessage.destroy(encrypted_message_uuid)
      return result
    end.error do
      return result
    end
  end

  private

  def decrypt_operation
    EncryptedMessage::DecryptWithPasswordOperation.new(
      encrypted_message_uuid: encrypted_message_uuid,
      password:               password
    )
  end
end
