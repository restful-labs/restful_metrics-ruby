require 'uri'
require 'yajl'
require 'rest_client'

# Analytico specific libs
require 'analytico/connection'
require 'analytico/endpoint'
require 'analytico/hash_utils'
require 'analytico/client'

# Rails integration libs
require 'analytico/railtie/rack_impression'

module Analytico
  
  REALM = "http://analytico.heroku.com"
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class AnalyticoError < StandardError; end
  class InsufficentArguments < AnalyticoError; end
  class InvalidAPIKey < AnalyticoError; end
  class NoConnectionEstablished < AnalyticoError; end
  
end