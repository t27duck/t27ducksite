require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

TEST_ENV_PASSWORD = 'testing'.freeze
StupidlySimpleAuthentication.instance_variable_set(
  '@config',
  'session_token' => '1234567890',
  'password_digest' => BCrypt::Password.create(TEST_ENV_PASSWORD).to_s
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_user
    post session_path, params: { password: TEST_ENV_PASSWORD }
  end
end
