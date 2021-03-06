# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ['Mikael Wikman']
  gem.email         = ['mikael@swedcontent.com']
  gem.description   = %q{Rule-based hash manipulator using custom DSL}
  gem.summary       = %q{ }
  gem.homepage      = "https://github.com/mikaelwikman/hashrules"

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|features)/})
  gem.name          = "hashrules"
  gem.require_paths = ["lib"]
  gem.version       = '1.1.4'
end
