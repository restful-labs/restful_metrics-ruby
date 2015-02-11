require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Endpoint generation" do
  
  it "should generate endpoints for metrics" do
    RestfulMetrics::Endpoint.metrics.should =~ /metrics.json/
  end
  
  it "should generate endpoints for compound metrics" do
    RestfulMetrics::Endpoint.compound_metrics.should =~ /compound_metrics.json/
  end


  describe '#endpoint_url' do
    let(:endpoint_url) { RestfulMetrics::Endpoint.endpoint_url('') }

    it 'generates URLs for track.restfulmetrics.com' do
      endpoint_url.should include 'track.restfulmetrics.com'
    end

    context 'when the RESTFUL_METRICS_REALM environment variable is set' do
      let(:realm) { 'track.example.com' }

      before do
        @original_env = ENV.to_hash
        ENV['RESTFUL_METRICS_REALM'] = 'https://track.example.com'
      end

      after do
        ENV.replace(@original_env)
      end

      it 'generates URLs for the given realm' do
        endpoint_url.should include realm
      end
    end

  end

end
