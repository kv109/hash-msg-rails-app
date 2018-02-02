module ApiHelper
  include Rack::Test::Methods

  def response_body
    last_response.body
  end

  def response_code
    last_response.status
  end

  def response_hash
    JSON.parse(response_body)
  end

  def req(method, path, options = {})
    url = "http://example.com/api/#{path}.json"
    send(method, url, options)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
