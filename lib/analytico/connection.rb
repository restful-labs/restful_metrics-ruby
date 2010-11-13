module Analytico

  class Connection

    attr_accessor :debug, :async
    attr_reader :api_key, :default_options

    def initialize(api_key)
      @api_key = api_key
      @default_options = { }
      @debug = false
      @async = false
    end

    def post(endpoint, data=nil)
      request :post, endpoint, data
    end

  private

    def request(method, endpoint, data=nil)
      headers = { 'User-Agent' => "Analytico Ruby Client v#{VERSION}",
                  'Content-Type' => "application/json" }
      
      if data.nil?
        data = @default_options
      else
        data.merge!(@default_options)
      end

      if debug
        puts "request: #{method.to_s.upcase} #{endpoint}"
        puts "headers:"
        headers.each do |key, value|
          puts "#{key}=#{value}"
        end
        if [:post, :put].include?(method)
          puts "data:"
          puts Yajl::Encoder.encode data
        end
      end

      begin
        data = Yajl::Encoder.encode data
      rescue
        logger("there was an error encoding your submission: #{$!}")
        return nil
      end
        
      response = send_request(method, endpoint, headers, data)

      if debug
        if response.nil?
          puts "There was an error processing the response from Analytico."
        else
          puts "\nresponse: #{response.code}"
          puts "headers:"
          response.header.each do |key, value|
            puts "#{key}=#{value}"
          end
          puts "body:"
          puts response.body
        end
      end

      if response.nil? || response.body.empty?
        content = nil
      else
        begin
          content = Yajl::Parser.new.parse(response.body)
        rescue
          logger("received invalid response: #{$!}")
          return "{}"
        end
      end

      content
    end

    def send_request(method, endpoint, headers, data=nil)      
      begin
        if @async
          response = RestClient::Request.execute(:method => :post, 
                                                 :url => endpoint, 
                                                 :payload => data, 
                                                 :headers => headers)
        else
          response = RestClient::Request.execute(:method => :post, 
                                                 :url => endpoint, 
                                                 :payload => data, 
                                                 :headers => headers, 
                                                 :timeout => 0.1)
        end
      rescue => e
        logger("there was an error transmitting your entry: #{$!}")
        return nil
      end

      response
    end
    
    def logger(error_msg)
      msg = "%%%% There was an error communicating with Analytico: #{error_msg}"
      if defined? Rails
        Rails.logger.info msg
      else
        STDERR.puts msg
      end
    end

  end

end
