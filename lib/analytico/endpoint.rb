module Analytico

  class Endpoint

    class << self
      
      def impressions
        endpoint_url "impressions.json"
      end
      
      def metrics
        endpoint_url "metrics.json"
      end

      def endpoint_url(path)
        [REALM, path].join('/')
      end

    end

  end

end
