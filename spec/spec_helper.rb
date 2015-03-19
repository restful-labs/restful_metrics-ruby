$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_support'
require 'active_support/core_ext'
require 'active_support/test_case'
require 'action_controller'
require 'action_dispatch/testing/test_process'
require 'action_dispatch/testing/test_request'
require 'action_dispatch/testing/test_response'

require 'rspec'
require 'mocha'
require 'restful_metrics'

include Rack::Test::Methods

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_framework = :mocha
end
