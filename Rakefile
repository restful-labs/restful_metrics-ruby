require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "restful_metrics"
  gem.summary = %Q{Ruby client for Restful Metrics}
  gem.description = %Q{Ruby client for the Restful Metrics service.}
  gem.email = "mgomes@geminisbs.com"
  gem.homepage = "http://github.com/geminisbs/restful_metrics-ruby"
  gem.authors = ["Mauricio Gomes"]
  
  gem.add_dependency "yajl-ruby", "~> 0.8.2"
  gem.add_dependency "rest-client", "~> 1.6.0"
  
  gem.add_development_dependency "rack", "> 1.0.0"
  gem.add_development_dependency "i18n"
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "delayed_job", "< 2.1.0"
  gem.add_development_dependency "rspec", "< 2.0.0"
  
  gem.files = FileList['lib/**/*.rb', 'VERSION', 'LICENSE', "README.rdoc"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
require 'mocha'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "api_auth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
