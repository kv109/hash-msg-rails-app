class EncryptedMessage::Create::FromCreateWithPasswordFormOperation
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def call
    if !form.valid?
      return Coman::Response.error(messages: form.errors.full_messages, result: form)
    end

    operation = EncryptWithPasswordOperation.new(
      decrypted_content: form.decrypted_content,
      password:          form.password
    )

    response = operation.call

    if response.ok?
      encrypted_content = response.result
      encrypted_message = EncryptedMessage.new(
        encrypted_content: encrypted_content,
        expires_in_hours:  form.expires_in_hours,
        question:          form.question
      )
      if encrypted_message.save
        Coman::Response.ok(result: { uuid: encrypted_message.uuid })
      else
        Coman::Response.error(result: encrypted_message, messages: encrypted_message.errors.full_messages)
      end
    elsif response.error?
      response
    end
  end
end
