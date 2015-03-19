# RESTful Metrics Ruby Client

Tracks your app's custom business metrics in your Ruby apps.

For more detailed instructions, check out our [Dev Center](http://devcenter.restful-labs.com/metrics/ruby_initialize).

## Install

* Please note the syntax for version 2.x of the Ruby client has changed. *

```
  gem install restful_metrics
```

## Configure

### Setting your API Key

The only step required for initialization is setting your API key. Once it's set, it's stored in memory while your Ruby program runs. You set your API key with the following command:

``` ruby
  RestfulMetrics::Client.set_credentials('214c7da8edd333abc78712313918ffe5')
```

### Disable Flag

The client also has an optional flag that prevents the client from actually sending data points to the server. This allows you to keep your RESTful Metrics tracking code in place even in your test enviornments. You can disable the client with the following (by default the client is enabled):

``` ruby
  RestfulMetrics::Client.disabled = true unless ENV == 'production'
```

We added the optional conditional check in the above example to illustrate how the flag can be set dynamically during your application's launch.

### Asynchronous Transmission

You can wrap all your RESTful Metrics calls with Delayed::Job / Resque / Sidekiq, etc.

For example:

``` ruby
  module CompoundMetric
    @queue = :metrics

    def self.perform(fqdn, name, values, timestamp=nil, distinct_id=nil)
      RestfulMetrics::Client.add_compound_metric :app => fqdn,
                                                 :name => name,
                                                 :values => values,
                                                 :occurred_at => timestamp,
                                                 :distinct_id => distinct_id
    end
  end

  module Metric
    @queue = :metrics

    def self.perform(fqdn, name, value, timestamp=nil, distinct_id=nil)
      RestfulMetrics::Client.add_metric :app => fqdn,
                                        :name => name,
                                        :value => value,
                                        :occurred_at => timestamp,
                                        :distinct_id => distinct_id
    end
  end
```

We've now separated the metrics and compound metrics into their own queue called `metrics`. To add a compound metric data point, we call:

``` ruby
    Resque.enqueue CompoundMetric, :app => 'myapp.com',
                                   :name => 'impression',
                                   :values => ['apple juice', 'orange juice', 'soda'],
                                   :occurred_at => Time.now,
                                   :distinct_id => user.uuid
```

## Sending Data Points

### Metrics

So given the following values for the attributes:

Attribute                 | Value
-------------             | -------------
Application Identifier    | "myapp.com"
Metric Name               | "impression"
Value                     | 1
Occurred At               | Time or DateTime object
Distinct User Identifier  | "fe352fe23e823668e23e7"

You would transmit this data point with the following:

``` ruby
  RestfulMetrics::Client.add_metric(:app => "myapp.com", :name => "impression", :value => 1, :occurred_at => Time.now, :distinct_id => "fe352fe23e823668e23e7")
```

### Compound Metrics

So given the following values for the attributes:

Attribute                 | Value
-------------             | -------------
Application Identifier    | "myapp.com"
Compound Metric Name      | "beverage_search"
Values                    | ["apple juice", "orange juice", "soda"]
Occurred At               | Time or DateTime object
Distinct User Identifier  | "fe352fe23e823668e23e7"

You would transmit this data point with the following:

``` ruby
  RestfulMetrics::Client.add_compound_metric(:app => "myapp.com", :name => "impression", :values => ["apple juice", "orange juice", "soda"], :occurred_at => Time.now, :distinct_id => "fe352fe23e823668e23e7")
```

## Copyright

Copyright (c) 2011-2012 RESTful Labs LLC. See LICENSE for details.

## Authors

* [Mauricio Gomes](http://github.com/mgomes)
* [Dan Porter](http://github.com/wolfpakz)
