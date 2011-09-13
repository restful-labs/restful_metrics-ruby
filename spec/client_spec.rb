require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "A NON-initialized Restful Metrics client" do
  
  it "should NOT send a metric data point" do
    lambda { 
      RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1)
    }.should raise_error(RestfulMetrics::NoConnectionEstablished)
  end
  
  it "should NOT send a compound metric data point" do
    lambda { 
      RestfulMetrics::Client.add_compound_metric("foo.bar.org", "hit", [1,2,3])
    }.should raise_error(RestfulMetrics::NoConnectionEstablished)
  end
  
  describe "in a Heroku environment" do
    
    before(:each) do
      ENV["RESTFUL_METRICS_API_KEY"] = "xyz123"
      RestfulMetrics::Connection.any_instance.stubs(:post).returns(100)
    end
    
    it "should send a metric data point" do
      rails_env "production" do
        RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_true
      end
    end
  
    it "should send a compound metric data point" do
      rails_env "production" do
        RestfulMetrics::Client.add_compound_metric("foo.bar.org", "hit", [1,2,3]).should be_true
      end
    end
    
  end
  
end

describe "A disabled Restful Metrics client" do
  
  before(:each) do
    RestfulMetrics::Client.disabled = true
  end
  
  it "should identify itself as disabled" do
    RestfulMetrics::Client.disabled?.should == true
  end
  
  it "should NOT send a metric if the client is in disabled-mode" do
    RestfulMetrics::Client.expects(:transmit).never
    RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should == false
  end
  
  it "should NOT send a compound metric if the client is in disabled-mode" do
    RestfulMetrics::Client.expects(:transmit).never
    RestfulMetrics::Client.add_compound_metric("foo.bar.org", "hit", [1,2,3]).should == false
  end
  
end

describe "An initialized Restful Metrics client" do
  
  before(:each) do
    @connection = RestfulMetrics::Connection
    @connection.any_instance.stubs(:post).returns(true)
    RestfulMetrics::Client.set_credentials('xyz123')
    RestfulMetrics::Client.disabled = false
    Delayed::Job.reset
  end
  
  describe "initializing the client" do
    
    it "should set the API key" do
      RestfulMetrics::Client.set_credentials('4ed4ef44e44ed4').should be_true
    end
    
    it "should set async mode when delayed_job is loaded" do
      RestfulMetrics::Client.async = true
      RestfulMetrics::Client.async?.should be_true
    end
    
  end
  
  describe "environment detection" do
    
    it "should return false if NOT in production" do
      rails_env "development" do
        RestfulMetrics::Client.expects(:logger).returns('')
        RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_false
      end
    end
    
    it "should successfully send the request if in Rails production mode" do
      rails_env "production" do
        @connection.any_instance.stubs(:post).returns(100)
        RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_true
      end
    end
    
    it "should successfully send the request if in Rack production mode" do
      RACK_ENV = "production"
      @connection.any_instance.stubs(:post).returns(100)
      RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_true
    end
    
  end

  describe "adding metrics synchronously" do
    
    before(:all) do
      RestfulMetrics::Client.async = false
      RestfulMetrics::Client.async?.should be_false
    end
    
    it "should send the metric to Restful Metrics" do
      rails_env "production" do
        @connection.any_instance.expects(:post).at_least_once.returns({})
        RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_true
      end
    end
    
    it "should send the compound metric to Restful Metrics" do
      rails_env "production" do
        @connection.any_instance.expects(:post).at_least_once.returns({})
        RestfulMetrics::Client.add_compound_metric("foo.bar.org", "hit", [1,2,3]).should be_true
      end
    end
    
  end

  describe "adding metrics asynchronously" do
    
    before(:all) do
      RestfulMetrics::Client.async = true
      RestfulMetrics::Client.async?.should be_true
    end
    
    it "should create a delayed job for the metric" do
      rails_env "production" do
        RestfulMetrics::Client.add_metric("foo.bar.org", "hit", 1).should be_true
        Delayed::Job.count.should == 1
      end
    end
    
    it "should create a delayed job for the compound metric" do
      rails_env "production" do
        RestfulMetrics::Client.add_compound_metric("foo.bar.org", "hit", [1,2,3]).should be_true
        Delayed::Job.count.should == 1
      end
    end
    
  end
  
end
