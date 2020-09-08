ENV['RAILS_ENV'] ||= 'test'
ENV_SELENIUM_HOST = ENV.fetch('SELENIUM_HOST')

require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
DatabaseCleaner.url_whitelist = ['postgres://hash-msg_test:hash-msg_test@postgres-test:5432/hash-msg_test']

RSpec.configure do |config|

  # TODO: set only in js: true tests
  if ENV_SELENIUM_HOST
    Capybara.javascript_driver = :selenium_remote_firefox
    Capybara.default_max_wait_time = 1.second
    Capybara.register_driver :selenium_remote_firefox do |app|
      Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: "http://#{ENV_SELENIUM_HOST}:4444/wd/hub",
          desired_capabilities: :firefox)
    end
    Capybara::Screenshot.register_driver :selenium_remote_firefox do |driver, path|
      driver.browser.save_screenshot path
    end
  end

  config.before(:each) do
    if /selenium_remote/.match Capybara.current_driver.to_s
      ip = `/sbin/ip route|awk '/scope/ { print $9 }'`
      ip = ip.gsub "\n", ""
      Capybara.server_port = "3000"
      Capybara.server_host = ip
      Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
    end
  end

  config.after(:each) do
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
