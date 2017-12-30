module ApiHelper
  include Rack::Test::Methods

  def response_code
    last_response.status
  end

  def response_hash
    JSON.parse(last_response.body)
  end

  def req(method, path, options = {})
    url = "http://example.com/api/#{path}.json"
    send(method, url, options)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
