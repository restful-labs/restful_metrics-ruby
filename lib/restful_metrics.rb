require 'uri'
require 'yajl'
require 'rest_client'

if !defined?(Logger)
  require 'logger'
end

# Restful Metrics specific libs
require 'restful_metrics/log_tools'
require 'restful_metrics/connection'
require 'restful_metrics/endpoint'
require 'restful_metrics/client'

# Rails integration
require 'restful_metrics/railtie/cookie_integration'  

module RestfulMetrics
  
  REALM = "http://track.restfulmetrics.com"
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class RestfulMetricsError < StandardError; end
  class InsufficentArguments < RestfulMetricsError; end
  class InvalidAPIKey < RestfulMetricsError; end
  class NoConnectionEstablished < RestfulMetricsError; end
  
end
