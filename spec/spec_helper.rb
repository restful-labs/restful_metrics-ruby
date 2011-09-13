$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_process'

require 'rspec'
require 'mocha'
require 'restful_metrics'
require 'delayed_job'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_framework = :mocha
end

#
# Use a mock backend for testing
#
Delayed::Worker.backend = :mock

#
# Fake the rails environment for testing
#
class Rails; cattr_accessor :env; end

# Simulate Rails enviornments
def rails_env(env, &block)
  old_env = Rails.env
  Rails.env = env
  yield
  Rails.env = old_env
end
