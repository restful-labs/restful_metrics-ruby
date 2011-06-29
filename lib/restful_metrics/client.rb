module RestfulMetrics

  class Client
    
    extend LogTools

    @@connection = nil
    @@debug, @@async, @@disabled = false

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

      def debug
        @@debug
      end
      
      def async=(async_flag)
        # DelayedJob integration
        require 'delayed_job' if async_flag
        
        @@async = async_flag && (defined?(Delayed) != nil)
        @@connection.async = @@async if @@connection
      end
      
      def async?
        @@async
      end
      
      def disabled=(disabled_flag)
        @@disabled = disabled_flag
      end
      
      def disabled?
        @@disabled
      end
      
      def add_metric(fqdn, name, value, distinct_id = nil)
        params = Hash.new
        params[:metric] = Hash.new
        params[:metric][:fqdn] = fqdn
        params[:metric][:name] = name
        params[:metric][:value] = value
        unless distinct_id.nil?
          params[:metric][:distinct_id] = distinct_id
        end
        
        post(Endpoint.metrics, params)
      end
      
      def add_compound_metric(fqdn, name, values, distinct_id = nil) 
        params = Hash.new
        params[:compound_metric] = Hash.new
        params[:compound_metric][:fqdn] = fqdn
        params[:compound_metric][:name] = name
        params[:compound_metric][:values] = values
        unless distinct_id.nil?
          params[:compound_metric][:distinct_id] = distinct_id
        end
        
        post(Endpoint.compound_metrics, params)
      end

    private
    
      def post(endpoint, data=nil)
        return false if disabled?
        raise NoConnectionEstablished if @@connection.nil?
        
        unless production_env?
          logger "Skipping while not in production", :info
          return false
        end
        
        if async?
          self.delay.transmit endpoint, data
          true
        else
          transmit endpoint, data
        end
      end
      
      def transmit(endpoint, data)
        begin
          @@connection.post(endpoint, data)
          true
        rescue
          logger "There was an error communicating with the server"
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

      def production_env?
        return true if defined?(RAILS_ENV) && RAILS_ENV == "production"
        return true if defined?(RACK_ENV) && RACK_ENV == "production"
        
        if defined?(Rails.env) && Rails.env == "production"
          return true
        end
        
        false
      end

    end

  end

end
