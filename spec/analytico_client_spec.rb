require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#
# Use a mock backend for testing
#
Delayed::Worker.backend = :mock

describe Analytico::Client do
  before(:each) do
    @connection = Analytico::Connection
    @connection.any_instance.stubs(:post).returns(true)
    @client = Analytico::Client
    @client.set_credentials('xyz123')
    Delayed::Job.reset
  end

  describe "add_impression" do
    it "should not record an impression without :fqdn" do
      @connection.any_instance.expects(:post).never
      @client.add_impression({}).should be_true
    end

    it "should not record an impression without :ip" do
      @connection.any_instance.expects(:post).never
      @client.add_impression({}).should be_true
    end

    it "requires :fqdn and :ip to record an impression" do
      @connection.any_instance.stubs(:post).returns({"code" => "bar"})
      o = @client.add_impression :fqdn => "foo.bar.org", :ip => "1.2.3.4"
      o.should be_kind_of Hash
      o.should include(:code)
      o[:code].should == "bar"
    end
  end

  describe "async_impression" do
    it "should create a delayed job to send an impression" do
      @client.async_impression :fqdn => "foo.bar.org", :ip => "1.2.3.4", :bam => "fu"
      Delayed::Job.count.should == 1
    end
  end

  describe "add_metric" do
    it "should sends a metric to analytico" do
      @connection.any_instance.expects(:post).at_least_once.returns({})
      @client.add_metric("foo.bar.org", "ding", "dong")
    end
  end

  describe "async_metric" do
    it "should create a delayed job" do
      @client.async_metric("pop.rocks.com", "snap", "crackle")
      Delayed::Job.count.should == 1
    end
  end
end
