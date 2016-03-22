# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stewfinder/version'

Gem::Specification.new do |spec|
  spec.name          = 'stewfinder'
  spec.version       = Stewfinder::VERSION
  spec.authors       = ['Alexander Standke']
  spec.email         = ['alexander.standke@appfolio.com']
  spec.summary       = "Get it while it's hot!"
  spec.description   = 'Finds stewards for a given file.'
  spec.homepage      = 'https://github.com/appfolio/stewfinder'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = 'exe'
  spec.executables   = ['stewfinder']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
