class DecryptWithPasswordOperation
  def initialize(encrypted_content:, password:)
    @encrypted_content = encrypted_content
    @password = password
  end

  def call
    decrypted_content = Cipher.decrypt_with_password(encrypted_content: encrypted_content, password: password)
    Coman::Response.ok(result: decrypted_content)
  rescue OpenSSL::Cipher::CipherError => e
    message = e.message == 'bad decrypt' ? 'wrong password' : e.message
    Coman::Response.error(messages: [message])
  end

  private

  attr_reader :encrypted_content, :password
end
