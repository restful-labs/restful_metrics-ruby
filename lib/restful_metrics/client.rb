module RestfulMetrics

  class Client

    extend LogTools

    @@connection = nil
    @@debug, @@disabled = false

    class << self

      def set_credentials(api_key)
        @@connection = Connection.new(api_key)
        self.debug = @@debug
        true
      end

      def debug=(debug_flag)
        @@debug = debug_flag
        @@connection.debug = @@debug if @@connection
      end

      def debug?
        @@debug
      end

      def disabled=(disabled_flag)
        @@disabled = disabled_flag
      end

      def disabled?
        @@disabled
      end

      def add_metric(*args)
        options = extract_options!(args)

        params = Hash.new
        params[:metric] = Hash.new
        params[:metric][:fqdn] = options[:app]
        params[:metric][:name] = options[:name]
        params[:metric][:value] = options[:value]

        unless options[:distinct_id].nil?
          params[:metric][:distinct_id] = options[:distinct_id]
        end

        unless options[:occurred_at].nil?
          raise InvalidTimestamp unless options[:occurred_at].respond_to?(:to_i)
          params[:metric][:occurred_at] = options[:occurred_at].to_i
        end

        post(Endpoint.metrics, params)
      end

      def add_compound_metric(*args)
        options = extract_options!(args)

        params = Hash.new
        params[:compound_metric] = Hash.new
        params[:compound_metric][:app] = options[:app]
        params[:compound_metric][:name] = options[:name]
        params[:compound_metric][:values] = options[:values]

        unless options[:distinct_id].nil?
          params[:compound_metric][:distinct_id] = options[:distinct_id]
        end

        unless options[:occurred_at].nil?
          raise InvalidTimestamp unless options[:occurred_at].respond_to?(:to_i)
          params[:compound_metric][:occurred_at] = options[:occurred_at].to_i
        end

        post(Endpoint.compound_metrics, params)
      end

    private

      def post(endpoint, data=nil)
        if disabled?
          logger "Skipping data points (client disabled)", :info
          return false
        end

        raise NoConnectionEstablished if @@connection.nil?

        transmit(endpoint, data)
      end

      def transmit(endpoint, data)
        begin
          @@connection.post(endpoint, data)
          true
        rescue
          logger "There was an error communicating with the server: #{$!}"
          false
        end
      end

      def extract_options!(args)
        if args.last.is_a?(Hash)
          return args.pop
        else
          return {}
        end
      end

    end

  end

end
