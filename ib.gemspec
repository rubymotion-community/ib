# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yury Korolev"]
  gem.email         = ["yury.korolev@gmail.com"]
  gem.description   = %q{Stupid rubymotion ib outlets support}
  gem.summary       = %q{Small portion of love to interface builder with rubymotion}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ib"
  gem.require_paths = ["lib"]
  gem.version       = IB::VERSION

  gem.add_dependency "xcodeproj", ">= 0.2.3"
  gem.add_dependency "thor", "~> 0.15.4"

  gem.add_development_dependency "rspec", ">= 2.0"
end
