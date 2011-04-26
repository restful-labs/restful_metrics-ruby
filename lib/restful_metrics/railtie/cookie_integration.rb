module RestfulMetrics

  module ControllerMethods # :nodoc:
    
    module InstanceMethods # :nodoc:
      
      private

        def restful_metrics_cookie
          if cookies
            if cookies[:analytico]
              cookie_value = cookies[:analytico]
            elsif cookies[:restful_metrics]
              cookie_value = cookies[:restful_metrics]
            else
              cookie_value = generate_distinct_id
              cookies[:restful_metrics] = {
                :value => cookie_value,
                :expires => 2.years.from_now,
                :domain => request.host
              }
            end
    
            cookie_value
          else
            nil
          end
    		end
	
    		def generate_distinct_id
    		  digest = Digest::MD5.new
    		  digest << "#{Time.now}-#{rand(999999)}"
    		  digest.to_s
    		end
  		
  	end
  	
  	if defined?(ActionController::Base)        
      ActionController::Base.send(:include, ControllerMethods::InstanceMethods)
    end
  
  end
  
end
