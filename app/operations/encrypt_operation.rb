class EncryptOperation
  attr_reader :decrypted_content, :password

  def initialize(decrypted_content:, password:)
    @decrypted_content = decrypted_content
    @password = password
  end

  def call
    encrypted_content = Cipher.encrypt(decrypted_content: decrypted_content, password: password)
    Coman::Response.ok(result: encrypted_content)
  end
end
