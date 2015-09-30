# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'traject/profiling/version'

Gem::Specification.new do |spec|
  spec.name          = 'traject_profiling'
  spec.version       = Traject::Profiling::VERSION
  spec.authors       = ['Naomi Dushay']
  spec.email         = ['ndushay@stanford.edu']
  spec.summary       = 'Traject macros to provide profiling information on MARC bibliographic records.'
  spec.description   = 'Profiling macros for MARC bib records; meant to be used with traject to index MARC records into Solr.'
  spec.homepage      = 'https://github.com/sul-dlss/traject_profiling.git'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib', 'lib/traject', 'lib/traject/profiling']

  spec.add_runtime_dependency 'traject'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry' # interactive debugging gem
  spec.add_development_dependency 'pry-byebug' # interactive debugging gem
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
