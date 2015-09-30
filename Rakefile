begin
  require 'bundler'
  require 'bundler/gem_tasks'
rescue LoadError => e
  warn e.message
  warn 'Run `gem install bundler` to install Bundler.'
  exit(-1)
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems.'
  exit e.status_code
end

require 'rake'

begin
  require 'yard'
  YARD::Rake::YardocTask.new
  task doc: :yard
rescue LoadError
  # yard not available - we're probably on a prod environment or need to run bundle install
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  # rspec not available - we're probably on a prod environment or need to run bundle install
end
