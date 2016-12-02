class EncryptedMessage::DecryptAndDestroyOperation
  attr_reader :encrypted_message_uuid, :password

  include Wisper::Publisher

  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    decrypt_operation
      .on(:error) do |error_messages|
        broadcast(:error, error_messages)
      end
      .on(:not_found) do |encrypted_message_uuid|
        broadcast(:not_found, encrypted_message_uuid)
      end
      .on(:ok) do |decrypted_content|
        EncryptedMessage.destroy(encrypted_message_uuid)
        broadcast(:ok, decrypted_content)
      end
      .call
  end

  private

  def decrypt_operation
    EncryptedMessage::DecryptOperation.new(
      encrypted_message_uuid: encrypted_message_uuid,
      password:               password
    )
  end
end
