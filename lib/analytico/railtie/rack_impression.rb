module AnalyticoController
  
  private
  
    def analytico_impression
      if cookies
        if cookies[:analytico]
          analytico_cookie = cookies[:analytico]
        else
          analytico_cookie = generate_cookie
          cookies[:analytico] = {
            :value => analytico_cookie,
            :expires => 2.years.from_now,
            :domain => request.host
          }
        end
      
        Analytico::Client.add_impression(:fqdn => request.host, 
                                         :ip => request.ip, 
                                         :user_agent => request.user_agent, 
                                         :referrer => request.referrer, 
                                         :url => request.path,
                                         :cookie => analytico_cookie)
      else
        Analytico::Client.add_impression(:fqdn => request.host, 
                                         :ip => request.ip, 
                                         :user_agent => request.user_agent, 
                                         :referrer => request.referrer, 
                                         :url => request.path)
      end
		end
		
		def generate_cookie
		  digest = Digest::MD5.new
		  digest << "#{Time.now}-#{rand(999999)}"
		  digest.to_s
		end
  
end

if defined? ActionController
  ActionController::Base.send :include, AnalyticoController
end
