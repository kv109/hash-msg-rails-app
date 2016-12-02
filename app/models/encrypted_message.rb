require 'aes'

class EncryptedMessage
  include ActiveModel::Model

  attr_accessor :encrypted_content, :question, :uuid

  validates! :encrypted_content, presence: true

  class << self
    def construct_from_hash(hash)
      EncryptedMessage.new(
        encrypted_content: hash.fetch('encrypted_content'),
        question: hash.fetch('question')
      )
    end

    def destroy(uuid)
      storage.del(uuid)
    end

    def find(uuid)
      json = storage.get(uuid)
      return nil unless json
      construct_from_hash(JSON.parse(json))
    end

    private

    def cipher
      AES
    end

    def storage
      RedisHM
    end
  end

  def cipher
    self.class.send :cipher
  end

  def decrypted_content(password)
    cipher.decrypt(encrypted_content, password)
  end

  def to_json
    { encrypted_content: encrypted_content, question: question }.to_json
  end

  def save
    self.uuid = SecureRandom.hex(13)
    storage.set(self.uuid, self.to_json)
  end

  private

  def storage
    self.class.send :storage
  end
end
