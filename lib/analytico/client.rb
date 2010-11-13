require 'active_support/core_ext'
require 'delayed_job'

module Analytico

  class Client

    @@connection = nil
    @@debug, @@async = false

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
        @@async = async_flag
        @@connection.async = @@async if @@connection
      end
      
      def async
        @@async
      end
      
      def add_impression(*args)
        raise NoConnectionEstablished  if @@connection.nil?
        
        options = extract_options!(args)
        if options[:fqdn].nil? || options[:ip].nil?
          return true
        end
        params = Hash.new
        params[:impression] = options
        params[:impression][:api_key] = @@connection.api_key
        
        response = post(Endpoint.impressions, params)
        HashUtils.recursively_symbolize_keys(response)
      end
      
      def add_metric(fqdn, name, value)
        raise NoConnectionEstablished  if @@connection.nil?
        
        params = Hash.new
        params[:metric] = Hash.new
        params[:metric][:api_key] = @@connection.api_key
        params[:metric][:fqdn] = fqdn
        params[:metric][:name] = name
        params[:metric][:value] = value
        
        response = post(Endpoint.metrics, params)
        HashUtils.recursively_symbolize_keys(response)
      end

      def post(endpoint, data=nil)
        unless production_env?
          warn "%%% Analytico %%% Skipping while not in production. Would have sent (async: #{@@async ? 'on' : 'off' }): #{data.inspect}"
          return nil
        end
        if @@async
          self.send_later @@connection.post(endpoint, data)
        else
          @@connection.post endpoint, data
        end
      end

    private

      def extract_options!(args)
        if args.last.is_a?(Hash)
          return args.pop
        else
          return {}
        end
      end

      def production_env?
        return true if defined?(RAILS_ENV) && RAILS_ENV == "production"
        return true if defined?(Rails) && Rails.respond_to?(:env) && Rails.env == "production"
        return false
      end

    end

  end

end
