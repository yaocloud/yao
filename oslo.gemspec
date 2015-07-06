# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oslo/version'

Gem::Specification.new do |spec|
  spec.name          = "oslo"
  spec.version       = Oslo::VERSION
  spec.authors       = ["Uchio, KONDO"]
  spec.email         = ["udzura@udzura.jp"]
  spec.summary       = %q{OpenStack API Wrapper that rocks!!}
  spec.description   = %q{OpenStack API Wrapper that rocks!!}
  spec.homepage      = "https://github.com/udzura/oslo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", ">= 3"
  spec.add_development_dependency "test-unit-rr"
  spec.add_development_dependency "power_assert"
end
