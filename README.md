# RESTful Metrics Ruby Client

Tracks your app's custom business metrics in your Ruby apps.

For more detailed instructions, check out our [Dev Center](http://devcenter.restful-labs.com/metrics/ruby_initialize).

## Install

```
  gem install restful_metrics-ruby
```

## Configure

### Setting your API Key

The only step required for initialization is setting your API key. Once it's set, it's stored in memory while your Ruby program runs. You set your API key with the following command:

``` ruby
  RestfulMetrics::Client.set_credentials('214c7da8edd333abc78712313918ffe5')
```

You can skip this step if you've installed the RESTful Metrics Heroku Addon.

### Disable Flag

The client also has an optional flag that prevents the client from actually sending data points to the server. This allows you to keep your RESTful Metrics tracking code in place even in your test enviornments. You can disable the client with the following (by default the client is enabled):

``` ruby
  RestfulMetrics::Client.disabled = true unless ENV == 'production'
```

We added the optional conditional check in the above example to illustrate how the flag can be set dynamically during your application's launch.

### Asynchronous Mode

The client currently has built-in support for Delayed::Job. If you enable the asynchronous flag the client will automatically queue the data point for transmission to the server at a later time. This is highly recommended for applications that are sensitive to latency.

``` ruby
  RestfulMetrics::Client.async = true
```

If you use a worker library other than Delayed::Job, you can wrap all your RESTful Metrics calls. For example, if we were using Resque we might add this to an initializer:

``` ruby
  module CompoundMetric
    @queue = :metrics

    def self.perform(fqdn, name, values, distinct_id = nil)
      RestfulMetrics::Client.add_compound_metric(fqdn, name, values, distinct_id)
    end
  end

  module Metric
    @queue = :metrics

    def self.perform(fqdn, name, value, distinct_id = nil)
      RestfulMetrics::Client.add_metric(fqdn, name, value, distinct_id)
    end
  end

  def restful_metrics_add_data_point(metric_type, app, metric, value, distinct_id=nil)
    unless RestfulMetrics::Client.disabled?
      Resque.enqueue(metric_type, app, metric, value, distinct_id)
    end
  end
```

We've now separated the metrics and compound metrics into their own queue called `metrics`. To add a compound metric data point, we call:

``` ruby
    restful_metrics_add_data_point(CompoundMetric, "myapp.com", "impression", ["apple juice", "orange juice", "soda"], "fe352fe23e823668e23e7")
```

Make sure that the `async` flag is set to off. This flag only applies to the built-in Delayed::Job support.

## Sending Data Points

### Metrics

So given the following values for the attributes:

Attribute                 | Value
-------------             | -------------
Application Identifier    | "myapp.com"
Metric Name               | "impression"
Value                     | 1
Distinct User Identifier  | "fe352fe23e823668e23e7"

You would transmit this data point with the following:

``` ruby
  RestfulMetrics::Client.add_metric("myapp.com", "impression", 1, "fe352fe23e823668e23e7")
```

### Compound Metrics

So given the following values for the attributes:

Attribute                 | Value
-------------             | -------------
Application Identifier    | "myapp.com"
Compound Metric Name      | "beverage_search"
Values                    | ["apple juice", "orange juice", "soda"]
Distinct User Identifier  | "fe352fe23e823668e23e7"

You would transmit this data point with the following:

``` ruby
  RestfulMetrics::Client.add_compound_metric("myapp.com", "impression", ["apple juice", "orange juice", "soda"], "fe352fe23e823668e23e7")
```

## Copyright

Copyright (c) 2011-2012 RESTful Labs LLC. See LICENSE for details.

## Authors

* [Mauricio Gomes](http://github.com/mgomes)
* [Dan Porter](http://github.com/wolfpakz)
