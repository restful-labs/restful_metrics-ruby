require 'active_support/core_ext'
require 'delayed_job'

module Analytico

  class Client

    @@connection = nil
    @@debug = false

    class << self

      def set_credentials(api_key)
        @@connection = Connection.new(api_key)
        @@connection.debug = @@debug
        true
      end

      def debug=(debug_flag)
        @@debug = debug_flag
        @@connection.debug = @@debug if @@connection
      end

      def debug
        @@debug
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

      def async_impression(*args)
        self.send_later(:add_impression, *args)
      end

      def async_metric(*args)
        self.send_later(:add_metric, *args)
      end

      def post(endpoint, data=nil)
        @@connection.post endpoint, data
      end

    private

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
