# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "joaquin/version"

Gem::Specification.new do |spec|
  spec.name          = "joaquin"
  spec.version       = Joaquin::VERSION
  spec.authors       = ["Carlos Vidal"]
  spec.email         = ["nakioparkour@gmail.com"]
  spec.summary       = Joaquin::DESCRIPTION
  spec.description   = Joaquin::DESCRIPTION
  spec.homepage      = "https://github.com/nakiostudio/joaquin"
  spec.license       = "MIT"

  # Paths
  spec.files          = Dir["lib/**/*"] + %w(bin/joaquin README.md LICENSE)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths  = ["lib"]

  # Ruby
  spec.required_ruby_version = ">= 2.2.2"

  # Lib
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'ngrok-tunnel'
  spec.add_dependency 'commander', '>= 4.4.0', '< 5.0.0'

  # Development only
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
