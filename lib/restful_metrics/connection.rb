module RestfulMetrics

  class Connection

    include LogTools

    attr_accessor :debug, :async
    attr_reader :api_key, :default_options

    def initialize(api_key)
      @api_key = api_key
      @default_options = { :api_key => @api_key }
      @debug = false
      @async = false
    end

    def post(endpoint, data=nil)
      request :post, endpoint, data
    end

  private

    def request(method, endpoint, data=nil)
      headers = { 'User-Agent' => "Restful Metrics Ruby Client v#{VERSION}",
                  'Content-Type' => "application/json" }

      if data.nil?
        data = @default_options
      else
        data.merge!(@default_options)
      end

      if debug
        logger "request: #{method.to_s.upcase} #{endpoint}"
        logger "headers:"
        headers.each do |key, value|
          logger "#{key}=#{value}"
        end
        if [:post, :put].include?(method)
          logger "data:"
          logger Yajl::Encoder.encode data
        end
      end

      begin
        data = Yajl::Encoder.encode data
      rescue
        logger "there was an error encoding your submission: #{$!}"
        return nil
      end

      response = send_request(method, endpoint, headers, data)

      if debug
        if response.nil?
          logger "There was an error processing the response from Restful Metrics."
        else
          logger "Response Code: #{response.code}"
          logger "Response Headers:"
          response.headers.each do |key, value|
            logger "#{key}=#{value}"
          end
          logger "Body:"
          logger response.body
        end
      end

      if response.nil? || response.body.empty?
        content = nil
      else
        begin
          content = Yajl::Parser.new.parse(response.body)
        rescue
          logger "received invalid response: #{$!}"
          return "{}"
        end
      end

      content
    end

    def send_request(method, endpoint, headers, data=nil)
      begin
        response = RestClient::Request.execute(:method => :post,
                                               :url => endpoint,
                                               :payload => data,
                                               :headers => headers)
      rescue => e
        logger "there was an error transmitting your entry: #{$!}"
        return nil
      end

      response
    end

  end

end
