class Cipher
  require 'aes'

  class << self
    def decrypt(encrypted_content:, password:)
      key = generate_key(password: password)
      AES.decrypt(encrypted_content, key)
    rescue OpenSSL::Cipher::CipherError => e
      Rails.logger.warn(e.inspect)
      nil
    end

    def encrypt(decrypted_content:, password:)
      key = generate_key(password: password)
      AES.encrypt(decrypted_content, key)
    end

    private

    def generate_key(password:)
      password + Rails.application.secrets.fetch(:secret_key_base)
    end
  end
end
