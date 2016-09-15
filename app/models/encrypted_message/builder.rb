class EncryptedMessage::Builder
  class << self
    def build_from_create_form(params)
      encrypted_content = AES.encrypt(params.decrypted_content, params.password)
      EncryptedMessage.new(
        encrypted_content: encrypted_content,
        question:          params.question
      )
    end
  end
end