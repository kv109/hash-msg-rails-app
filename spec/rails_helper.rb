ENV['RAILS_ENV'] ||= 'test'
ENV_SELENIUM_HOST = ENV.fetch('SELENIUM_HOST')

require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  if ENV_SELENIUM_HOST
    Capybara.javascript_driver = :selenium_remote_firefox
    Capybara.register_driver "selenium_remote_firefox".to_sym do |app|
      Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: "http://#{ENV_SELENIUM_HOST}:4444/wd/hub",
          desired_capabilities: :firefox)
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
