class RedisHM
  class << self
    delegate :del, :get, :set, to: :client

    def client
      @client ||= Redis.new(url: ENV_REDIS_URL)
    end
  end
end