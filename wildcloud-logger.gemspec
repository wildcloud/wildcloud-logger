lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'wildcloud/logger/version'

Gem::Specification.new do |s|
  s.name        = 'wildcloud-logger'
  s.version     = Wildcloud::Logger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marek Jelen']
  s.email       = ['marek@jelen.biz']
  s.homepage    = 'http://github.com/wildcloud'
  s.summary     = 'Logging library extracted from Wildcloud project'
  s.description = 'Simple logging library inspired by Rack architecture'
  s.license     = 'Apache2'

  s.required_rubygems_version = '>= 1.3.6'

  s.files        = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.require_path = 'lib'
end