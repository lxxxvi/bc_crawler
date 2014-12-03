# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bc_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = 'bc_crawler'
  spec.version       = BcCrawler::VERSION
  spec.authors       = ['Mario Schuettel']
  spec.email         = ["github@lxxxvi.ch"]
  spec.summary       = 'Crawl Bandcamp Sites'
  spec.description   = 'Allows to crawl bandcamp sites, including release and track information'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'json', '>= 1.8.1'

  spec.add_runtime_dependency 'json', '>= 1.8.1'
end