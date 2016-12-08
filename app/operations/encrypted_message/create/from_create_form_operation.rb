class EncryptedMessage::Create::FromCreateFormOperation
  attr_reader :form

  def initialize(form:)
    @form = form
  end


  def call
    if !form.valid?
      return Op::Response.new(status: :error, messages: form.errors.full_messages, value: form)
    end

    operation = EncryptedMessage::EncryptOperation.new(
      decrypted_content: form.decrypted_content,
      password: form.password
    )

    response = operation.call

    if response.ok?
      encrypted_content = response.value
      encrypted_message = EncryptedMessage.new(
        encrypted_content: encrypted_content,
        question:          form.question
      )
      if encrypted_message.save
        Op::Response.new(status: :ok, value: encrypted_message)
      else
        Op::Response.new(status: :error, value: encrypted_message, messages: encrypted_message.errors.full_messages)
      end
    elsif response.error?
      response
    end
  end
end
