class EncryptedMessage::EncryptOperation
  require 'aes'

  attr_reader :decrypted_content, :password

  def initialize(decrypted_content:, password:)
    @decrypted_content = decrypted_content
    @password = password
  end

  def call
    encrypted_content = AES.encrypt(decrypted_content, key)
    Coman::Response.ok(result: encrypted_content)
  end

  private

  def key
    password + Rails.application.secrets.fetch(:secret_key_base)
  end

end
