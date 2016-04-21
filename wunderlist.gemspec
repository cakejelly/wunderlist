# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wunderlist/version'

Gem::Specification.new do |spec|
  spec.name          = "wunderlist"
  spec.version       = Wunderlist::VERSION
  spec.authors       = ["Jake Kelly"]
  spec.email         = ["jake.kelly10@gmail.com"]

  spec.summary       = "A ruby wrapper for Wunderlist's API"
  spec.description   = "A ruby wrapper for Wunderlist's API"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry", "~> 0.10.1"

  spec.add_dependency "rest-client"
end
