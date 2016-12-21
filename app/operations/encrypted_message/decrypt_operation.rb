class EncryptedMessage::DecryptOperation
  def initialize(encrypted_message_uuid:, password:)
    @encrypted_message_uuid = encrypted_message_uuid
    @password = password
  end

  def call
    if encrypted_message.nil?
      return Coman::Response.error(code: 404, result: encrypted_message_uuid)
    end

    ::DecryptOperation.new(encrypted_content: encrypted_message.encrypted_content, password: password).call
  end

  private

  attr_reader :encrypted_message_uuid, :password

  def encrypted_message
    EncryptedMessage.find(encrypted_message_uuid)
  end
end
