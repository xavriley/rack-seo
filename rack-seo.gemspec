# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-seo/version'

Gem::Specification.new do |gem|
  gem.name = "rack-seo"
  gem.version       = Rack::Seo::VERSION
  gem.homepage = "http://github.com/xavriley/rack-seo"
  gem.license = "MIT"
  gem.summary = "Generate and manage meta tags on the fly using Rack Middleware"
  gem.description = %q{Lets you extract sensible default content for meta tags using the markup from that page.}
  gem.email = ["xavriley@github.com"]
  gem.authors = ["Xavier Riley"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  #gem.add_dependency('nokogiri', ["~> 1.5.6"])
  #gem.add_dependency('summarize', ["~> 1.0.3"])
end

