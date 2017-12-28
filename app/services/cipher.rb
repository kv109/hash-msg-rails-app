class Cipher
  class << self
    def decrypt_with_password(encrypted_content:, password:)
      cipher = cipher()
      cipher.decrypt
      cipher.key = generate_key(password: password)
      cipher.update(encrypted_content) + cipher.final
    end

    def decrypt_with_token(encrypted_content:, token:)
      cipher = cipher()
      cipher.decrypt
      cipher.key = token
      cipher.update(encrypted_content) + cipher.final
    end

    def encrypt_with_password(decrypted_content:, password:)
      cipher = cipher()
      cipher.encrypt
      cipher.key = generate_key(password: password)
      cipher.update(decrypted_content) + cipher.final
    end

    def encrypt_with_token(decrypted_content:)
      cipher = cipher()
      cipher.encrypt
      token             = cipher.random_key
      cipher.key        = token
      encrypted_content = cipher.update(decrypted_content) + cipher.final
      { encrypted_content: encrypted_content, token: token }
    end

    private

    def cipher
      OpenSSL::Cipher::AES.new(128, :CBC)
    end

    def generate_key(password:)
      Digest::SHA256.digest(password + salt)[0..15]
    end

    def salt
      Rails.application.secrets.fetch(:secret_key_base)
    end
  end
end
