class Cipher
  class << self
    def decrypt(encrypted_content:, password:)
      cipher = cipher()
      cipher.decrypt
      cipher.key = generate_key(password: password)
      cipher.update(encrypted_content) + cipher.final
    end


    def encrypt(decrypted_content:, password:)
      cipher = cipher()
      cipher.encrypt
      cipher.key = generate_key(password: password)
      cipher.update(decrypted_content) + cipher.final
    end

    private

    def cipher
      OpenSSL::Cipher::AES.new(128, :CBC)
    end

    def generate_key(password:)
      "#{password}#{Rails.application.secrets.fetch(:secret_key_base)}"[0..50]
    end
  end
end
