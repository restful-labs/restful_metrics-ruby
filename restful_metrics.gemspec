# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{restful_metrics}
  s.summary = %q{Ruby client for the RESTful Metrics service.}
  s.description = %q{Ruby client for the RESTful Metrics service.}
  s.homepage = %q{http://github.com/restful-labs/resetful_metrics-ruby}
  s.version = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.authors = ["Mauricio Gomes"]
  s.email = "mauricio@restful-labs.com"

  s.add_dependency "yajl-ruby", ">= 0.8.1"
  s.add_dependency "rest-client", "~> 1.6.0"

  s.add_development_dependency "rspec", "~> 2.8.0"
  s.add_development_dependency "mocha", "~> 0.10.4"
  s.add_development_dependency "actionpack", "~> 3.0.0"
  s.add_development_dependency "rack", "~> 1.2.5"
  s.add_development_dependency "activesupport", "~> 3.0.0"
  s.add_development_dependency "delayed_job", "~> 3.0.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

