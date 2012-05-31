require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "A NON-initialized RESTful Metrics client" do

  it "should NOT send a metric data point" do
    lambda {
      RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1)
    }.should raise_error(RestfulMetrics::NoConnectionEstablished)
  end

  it "should NOT send a compound metric data point" do
    lambda {
      RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3])
    }.should raise_error(RestfulMetrics::NoConnectionEstablished)
  end

  describe "in a Heroku environment" do

    before(:each) do
      ENV["RESTFUL_METRICS_API_KEY"] = "xyz123"
      RestfulMetrics::Connection.any_instance.stubs(:post).returns(100)
    end

    it "should NOT send a metric data point" do
      lambda {
        RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1).should be_true
      }.should raise_error(RestfulMetrics::NoConnectionEstablished)
    end

    it "should NOT send a compound metric data point" do
      lambda {
        RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3]).should be_true
      }.should raise_error(RestfulMetrics::NoConnectionEstablished)
    end

  end

end

describe "A disabled RESTful Metrics client" do

  before(:each) do
    RestfulMetrics::Client.disabled = true
  end

  it "should identify itself as disabled" do
    RestfulMetrics::Client.disabled?.should == true
  end

  it "should NOT send a metric if the client is in disabled-mode" do
    RestfulMetrics::Client.expects(:transmit).never
    RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1).should == false
  end

  it "should NOT send a compound metric if the client is in disabled-mode" do
    RestfulMetrics::Client.expects(:transmit).never
    RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3]).should == false
  end

end

describe "An initialized RESTful Metrics client" do

  class SampleRequest

    def body
      '{ "test": "success" }'
    end

    def code
      200
    end

    def header
      { "one" => "test", "two" => "test" }
    end

  end

  before(:each) do
    @connection = RestfulMetrics::Connection
    RestfulMetrics::Client.set_credentials('xyz123')
    RestfulMetrics::Client.disabled = false
    RestClient::Request.any_instance.stubs(:execute).returns(SampleRequest.new)
    Logger.any_instance.stubs(:warn).returns("") # disable output
    Delayed::Job.delete_all
  end

  describe "in debug mode" do

    before(:all) do
      RestfulMetrics::Client.debug = true
      RestfulMetrics::Client.debug?.should be_true
      RestfulMetrics::Connection.any_instance.expects(:logger).at_least_once.returns("")
    end

    it "should send a metric to RESTful Metrics while outputting debug info" do
      RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1).should be_true
    end

    it "should send the compound metric to RESTful Metrics while outputting debug info" do
      RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3]).should be_true
    end

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

  describe "adding metrics synchronously" do

    before(:all) do
      RestfulMetrics::Client.async = false
      RestfulMetrics::Client.async?.should be_false
    end

    it "should send the metric to RESTful Metrics" do
      RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1, :occurred_at => Time.now).should be_true
    end

    it "should send the compound metric to RESTful Metrics" do
      RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3], :occurred_at => Time.now).should be_true
    end

  end

  describe "adding metrics asynchronously" do

    before(:all) do
      RestfulMetrics::Client.async = true
      RestfulMetrics::Client.async?.should be_true
    end

    it "should create a delayed job for the metric" do
      RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1, :occurred_at => Time.now).should be_true
      Delayed::Job.count.should == 1
    end

    it "should create a delayed job for the compound metric" do
      RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3], :occurred_at => Time.now).should be_true
      Delayed::Job.count.should == 1
    end

  end

  describe "raising errors" do

    before(:all) do
      RestfulMetrics::Client.async = false
      RestfulMetrics::Client.async?.should be_false
    end

    it "should NOT accept an invalid occurred_at timestamp when sending metrics" do
      lambda {
        RestfulMetrics::Client.add_metric(:app => "foo.bar.org", :name => "hit", :value => 1, :occurred_at => Date.today)
      }.should raise_error(RestfulMetrics::InvalidTimestamp)
      Delayed::Job.count.should == 0
    end

    it "should NOT accept an invalid occurred_at timestamp when sending compound metrics" do
      lambda {
        RestfulMetrics::Client.add_compound_metric(:app => "foo.bar.org", :name => "hit", :values => [1,2,3], :occurred_at => Date.today).should be_false
      }.should raise_error(RestfulMetrics::InvalidTimestamp)
      Delayed::Job.count.should == 0
    end

  end

end
