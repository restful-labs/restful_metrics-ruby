module RestfulMetrics

  class Endpoint

    class << self
      
      def metrics
        endpoint_url "metrics.json"
      end
      
      def compound_metrics
        endpoint_url "compound_metrics.json"
      end

      def endpoint_url(path)
        realm = (ENV['RESTFUL_METRICS_REALM'] || REALM)
        [realm, path].join('/')
      end

    end

  end

end
