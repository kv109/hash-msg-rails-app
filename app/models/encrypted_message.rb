require 'aes'

class EncryptedMessage
  include ActiveModel::Model

  attr_accessor :encrypted_content, :question, :uuid

  delegate :cipher, :storage, to: :class

  validates! :encrypted_content, presence: true

  def self.cipher
    AES
  end

  def self.construct_from_hash(hash)
    EncryptedMessage.new(
        encrypted_content: hash.fetch('encrypted_content'),
        question: hash.fetch('question')
    )
  end

  def self.find(uuid)
    json = storage.get(uuid)
    return nil unless json
    construct_from_hash(JSON.parse(json))
  end

  def self.find_and_destroy(uuid)
    encrypted_message = find(uuid)
    storage.del(uuid)
    encrypted_message
  end

  def self.storage
    RedisHM
  end

  def to_json
    { encrypted_content: encrypted_content, question: question }.to_json
  end

  def save
    self.uuid = SecureRandom.hex(13)
    storage.set(self.uuid, self.to_json)
  end

  def decrypted_content(password)
    cipher.decrypt(encrypted_content, password)
  end
end
