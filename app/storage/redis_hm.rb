class RedisHM
  class << self
    delegate :del, :flushall, :get, :keys, :set, to: :client

    def client
      @client ||= Redis.new(url: ENV_REDIS_URL)
    end
  end
end