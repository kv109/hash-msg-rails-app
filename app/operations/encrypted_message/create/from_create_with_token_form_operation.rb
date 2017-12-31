class EncryptedMessage::Create::FromCreateWithTokenFormOperation
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def call
    if !form.valid?
      return Coman::Response.error(messages: form.errors.full_messages, result: form)
    end

    operation = EncryptWithTokenOperation.new(decrypted_content: form.decrypted_content)

    response = operation.call

    if response.ok?
      encrypted_content_data = response.result
      encrypted_content      = encrypted_content_data.fetch(:encrypted_content)
      token                  = encrypted_content_data.fetch(:token)
      encrypted_message      = EncryptedMessage.new(encrypted_content: encrypted_content)

      if encrypted_message.save
        Coman::Response.ok(result: { token: token, uuid: encrypted_message.uuid })
      else
        Coman::Response.error(result: encrypted_message, messages: encrypted_message.errors.full_messages)
      end
    elsif response.error?
      response
    end
  end
end
