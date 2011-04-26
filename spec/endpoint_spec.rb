require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Endpoint generation" do
  
  it "should generate endpoints for metrics" do
    RestfulMetrics::Endpoint.metrics.should =~ /metrics.json/
  end
  
  it "should generate endpoints for compound metrics" do
    RestfulMetrics::Endpoint.compound_metrics.should =~ /compound_metrics.json/
  end
  
end
