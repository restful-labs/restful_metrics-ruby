module AnalyticoController
  
  private
  
    def analytico_impression
      Analytico::Client.add_impression(:fqdn => request.host, :ip => request.ip, :user_agent => request.user_agent, :referrer => request.referrer, :url => request.path)
		end
  
end

if defined? ActionController
  ActionController::Base.send :include, AnalyticoController
end
