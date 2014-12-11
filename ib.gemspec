# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yury Korolev", "Francis Chong", "Eloy Durán"]
  gem.email         = ["yury.korolev@gmail.com", "francis@ignition.hk", "eloy@hipbyte.com"]
  gem.description   = %q{Magic rubymotion ib outlets support}
  gem.summary       = %q{Small portion of love to interface builder with rubymotion}
  gem.homepage      = "https://github.com/rubymotion/ib"
  gem.licenses      = ['BSD']

  gem.files         = `git ls-files`.split($\).reject { |f| f =~ %r{samples/} }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ib"
  gem.require_paths = ["lib"]
  gem.version       = IB::VERSION

  gem.add_dependency 'xcodeproj', '~> 0.17'
  gem.add_dependency 'thor',      '~> 0.15.4'
  gem.add_dependency 'tilt',      '~> 1.4.1'

  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-bundler'
end
