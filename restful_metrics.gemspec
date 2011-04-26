# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{restful_metrics}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mauricio Gomes"]
  s.date = %q{2011-04-25}
  s.description = %q{Ruby client for the Restful Metrics service.}
  s.email = %q{mgomes@geminisbs.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "LICENSE",
    "VERSION",
    "lib/delayed/backend/mock.rb",
    "lib/restful_metrics.rb",
    "lib/restful_metrics/client.rb",
    "lib/restful_metrics/connection.rb",
    "lib/restful_metrics/endpoint.rb",
    "lib/restful_metrics/log_tools.rb",
    "lib/restful_metrics/railtie/cookie_integration.rb"
  ]
  s.homepage = %q{http://github.com/geminisbs/restful_metrics-ruby}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Ruby client for Restful Metrics}
  s.test_files = [
    "spec/client_spec.rb",
    "spec/cookie_integration_spec.rb",
    "spec/endpoint_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 0.8.1"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<actionpack>, [">= 2.3.9"])
      s.add_development_dependency(%q<activesupport>, [">= 2.3.9"])
      s.add_development_dependency(%q<delayed_job>, ["~> 2.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_development_dependency(%q<rack>, ["> 1.0.0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<delayed_job>, ["< 2.1.0"])
      s.add_development_dependency(%q<rspec>, ["< 2.0.0"])
    else
      s.add_dependency(%q<yajl-ruby>, ["~> 0.8.1"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<actionpack>, [">= 2.3.9"])
      s.add_dependency(%q<activesupport>, [">= 2.3.9"])
      s.add_dependency(%q<delayed_job>, ["~> 2.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
      s.add_dependency(%q<rack>, ["> 1.0.0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<delayed_job>, ["< 2.1.0"])
      s.add_dependency(%q<rspec>, ["< 2.0.0"])
    end
  else
    s.add_dependency(%q<yajl-ruby>, ["~> 0.8.1"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<actionpack>, [">= 2.3.9"])
    s.add_dependency(%q<activesupport>, [">= 2.3.9"])
    s.add_dependency(%q<delayed_job>, ["~> 2.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, ["~> 0.8.2"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.0"])
    s.add_dependency(%q<rack>, ["> 1.0.0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<delayed_job>, ["< 2.1.0"])
    s.add_dependency(%q<rspec>, ["< 2.0.0"])
  end
end
