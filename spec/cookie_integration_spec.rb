require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rails controller integration" do

  class TestController
    include RestfulMetrics::ControllerMethods::InstanceMethods

    def cookies
      @cookies ||= {}
    end

    def request
      require 'ostruct'

      struct = OpenStruct.new
      struct.host = 'foo.com'
      struct
    end
  end

  let(:test_controller) { TestController.new }

  describe '#restful_metrics_cookie' do
    let(:result) { test_controller.send(:restful_metrics_cookie) }

    it 'generates a distinct id' do
      test_controller.expects(:generate_distinct_id).once
      result
    end

    it 'sets the :restful_metrics cookie' do
      result
      test_controller.cookies[:restful_metrics].should be_present
    end

    context 'when the :analytico cookie exists' do
      let(:existing_cookie) { '1234123412341234' }

      before do
        test_controller.cookies[:analytico] = existing_cookie
      end

      it 'returns the existing cookie' do
        result.should == existing_cookie
      end
    end

    context 'when the :restful_metrics cookie exists' do
      let(:existing_cookie) { '897123408971234' }

      before do
        test_controller.cookies[:restful_metrics] = existing_cookie
      end

      it 'returns the existing cookie' do
        result.should == existing_cookie
      end
    end
  end

  describe '#generate_distinct_id' do
    let(:test_controller) { TestController.new }
    let(:result) { test_controller.send(:generate_distinct_id) }

    it 'returns a string' do
      result.class.should == String
    end

    it 'returns 32 characters' do
      result.length.should == 32
    end

    it 'returns unique ids' do
      ids = 100.times.collect { test_controller.send(:generate_distinct_id) }
      unique_ids = ids.sort.uniq

      ids.length.should == unique_ids.length
    end
  end
end
