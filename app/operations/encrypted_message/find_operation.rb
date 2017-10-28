class EncryptedMessage::FindOperation
  def initialize(uuid:)
    @uuid = uuid
  end

  def call
    if encrypted_message.nil?
      return Coman::Response.error(code: 404)
    else
      Coman::Response.ok(result: encrypted_message)
    end
  end

  private

  attr_reader :uuid

  def encrypted_message
    EncryptedMessage.find(uuid)
  end
end
