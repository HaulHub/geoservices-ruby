# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'geoservices/version'

Gem::Specification.new do |spec|
  spec.name          = 'geoservices'
  spec.version       = Geoservice::VERSION
  spec.authors       = ['Andrew Turner, Bruce Steedman']
  spec.email         = 'aturner@esri.com'

  spec.summary       = 'A simple wrapper for GeoServices API'
  spec.description   = 'A simple wrapper for ArcGIS REST (GeoServices) API'
  spec.homepage      = 'https://github.com/MatzFan/geoservices-ruby'
  spec.license       = 'APACHE'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-mocks', '~> 3.0'
end
