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
        [REALM, path].join('/')
      end

    end

  end

end
