class EncryptWithTokenOperation
  def initialize(decrypted_content:)
    @decrypted_content = decrypted_content
  end

  def call
    encrypted_content_data = Cipher.encrypt_with_token(decrypted_content: decrypted_content)
    Coman::Response.ok(result: encrypted_content_data)
  rescue OpenSSL::Cipher::CipherError => e
    Coman::Response.error(messages: e.message)
  end

  private

  attr_reader :decrypted_content
end
