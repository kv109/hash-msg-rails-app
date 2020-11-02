class EncryptedMessage
  DEFAULT_EXPIRES_IN_HOURS = 36
  private_constant :DEFAULT_EXPIRES_IN_HOURS

  include ActiveModel::Model

  attr_accessor :encrypted_content, :expires_in_hours, :question, :uuid

  validates! :encrypted_content, presence: true

  class << self
    def construct_from_hash(hash)
      encrypted_content = Base64.decode64(hash.fetch('encrypted_content'))
      EncryptedMessage.new(
        encrypted_content: encrypted_content,
        question:          hash['question']
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

    def storage
      RedisHM
    end
  end

  def expires_in
    self.expires_in_hours = self.expires_in_hours.to_i
    self.expires_in_hours = DEFAULT_EXPIRES_IN_HOURS if self.expires_in_hours.zero?
    self.expires_in_hours * 60 * 60
  end

  def to_json
    {
      encrypted_content: Base64.encode64(encrypted_content),
      question:          question
    }.to_json
  end

  def save
    self.uuid = SecureRandom.hex(13)
    storage.set(self.uuid, self.to_json, ex: expires_in)
  end

  private

  def storage
    self.class.send :storage
  end
end
