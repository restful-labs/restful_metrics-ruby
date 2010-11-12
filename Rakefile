require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "analytico"
    gem.summary = %Q{Ruby client for Analytico}
    gem.description = %Q{Ruby client for the Analytico impression and app metric tracking service.}
    gem.email = "mgomes@geminisbs.com"
    gem.homepage = "http://github.com/geminisbs/analytico_ruby"
    gem.authors = ["Mauricio Gomes"]
    
    gem.add_dependency "yajl-ruby", "~> 0.7.7"
    gem.add_dependency "rest-client", "~> 1.6.0"
    gem.add_dependency "rack", "> 1.0.0"
    gem.add_dependency "delayed_job", ">= 2.1.0pre2"
    
    gem.add_development_dependency "rspec", "< 2.0.0"
    
    gem.files = FileList['lib/**/*.rb', 'VERSION', 'LICENSE', "README.rdoc"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "analytico #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
