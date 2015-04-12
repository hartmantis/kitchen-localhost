# Encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/localhost/version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-localhost'
  spec.version       = Kitchen::Localhost::VERSION
  spec.authors       = ['Jonathan Hartman']
  spec.email         = %w(j@p4nt5.com)
  spec.description   = 'A Test Kitchen Driver for localhost'
  spec.summary       = 'Use Test Kitchen to run Chef on your local machine!'
  spec.homepage      = 'https://github.com/test-kitchen/kitchen-localhost'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'test-kitchen', '~> 1.4.0.rc'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.30'
  spec.add_development_dependency 'cane', '~> 2.6'
  spec.add_development_dependency 'countloc', '~> 0.4'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'simplecov-console', '~> 0.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'
end
