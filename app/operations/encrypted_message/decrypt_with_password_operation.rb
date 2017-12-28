class EncryptedMessage::DecryptWithPasswordOperation
  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password               = password
  end

  def call
    response = find_operation.call
    response.ok do |encrypted_message|
      # TODO: Fix Coman to return what evaluated block returned
      return ::DecryptWithPasswordOperation.new(
        encrypted_content: encrypted_message.encrypted_content,
        password:          password
      ).call
    end.error do
      return response
    end
  end

  private

  attr_reader :encrypted_message_uuid, :password

  def find_operation
    ::EncryptedMessage::FindOperation.new(uuid: encrypted_message_uuid)
  end
end
