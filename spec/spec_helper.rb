$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'analytico'
require 'spec'
require 'spec/autorun'
require 'delayed_job'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
