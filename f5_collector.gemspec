# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'f5_collector/version'

Gem::Specification.new do |spec|
  spec.name          = "f5_collector"
  spec.version       = F5Collector::VERSION
  spec.authors       = ["Alexandre Cardoso"]
  spec.email         = ["accbel@gmail.com"]
  spec.summary       = %q{F5 BigIp statistics collector}
  spec.description   = %q{A gem to inspect a F5 BigIp server/cluster for runtime statistics and return it to an Zabbix's agent call}
  spec.homepage      = "https://github.com/accbel/f5_collector"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib,conf,spec}/**/*") + %w(LICENSE.txt README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.1.0"
  spec.add_development_dependency "vcr", "2.9.3"
  spec.add_development_dependency "webmock", "1.20.4"
  spec.add_development_dependency "pry", "0.10.1"
  spec.add_development_dependency "gem-release", "0.7.3"

  spec.add_runtime_dependency "savon", "2.8.0"
end
