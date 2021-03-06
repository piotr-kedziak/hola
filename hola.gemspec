# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hola/version'

Gem::Specification.new do |spec|
  spec.name          = 'hola'
  spec.version       = Hola::VERSION
  spec.authors       = ['Piotr Kędziak']
  spec.email         = ['piotr@kedziak.com']

  spec.summary       = '¡Hola! framework test task'
  spec.description   = '¡Hola! framework test task desc'
  spec.homepage      = 'https://github.com/piotr-kedziak/hola'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to "http://mygemserver.com"'
  else
    fail 'RubyGems 2.0 is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack'

  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'terminal-notifier-guard'
end
