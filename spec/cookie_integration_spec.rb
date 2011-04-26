require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rails controller integration" do
  
  class ApplicationController < ActionController::Base
    
    before_filter :track_impression
    
    private
    
      def track_impression
        RestfulMetrics::Client.add_metric("foo.bar.org", "impression", 1, restful_metrics_cookie)
      end

  end
  
  class TestController < ApplicationController

    def index
      @distinct_id = restful_metrics_cookie
      RestfulMetrics::Client.add_metric("foo.bar.org", "custom", 1, @distinct_id)
      render :text => "OK"
    end

    def rescue_action(e); raise(e); end
  end
  ActionController::Routing::Routes.draw {|map| map.resources :test }
  
  before(:each) do
    RestfulMetrics::Connection.any_instance.stubs(:post).returns(true)
    RestfulMetrics::Client.set_credentials('xyz123')
    @request = ActionController::TestRequest.new
    @request.action = 'index'
    @request.path = "/index"
  end
  
  it "should track all metrics in the stack" do
    RestfulMetrics::Client.expects(:add_metric).twice.returns(true)
    TestController.new.process(@request, ActionController::TestResponse.new).code.should == "200"
  end
  
end
