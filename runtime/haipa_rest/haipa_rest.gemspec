# Copyright (c) dbosoft GmbH and Haipa Contributors. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'haipa_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'haipa_rest'
  spec.version       = Haipa::Client::REST_VERSION
  spec.authors       = 'Haipa Contributors'
  spec.email         = 'package-maintainers@haipa.io'

  spec.summary       = %q{Haipa Client Library for Ruby.}
  spec.description   = %q{Haipa Client Library for Ruby.}
  spec.homepage      = 'https://github.com/haipa/ruby-client'
  spec.license       = 'MIT'
  spec.metadata      = {
    'bug_tracker_uri' => 'https://github.com/haipa/haipa/issues',
    'documentation_uri' => 'https://github.com/haipa/ruby-client',
    'homepage_uri' => 'https://github.com/haipa/ruby-client',
    'source_code_uri' => "https://github.com/haipa/ruby-client"
  }

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/*"]
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'unf_ext', '0.0.7.2'
  spec.add_runtime_dependency 'faraday', '~> 0.9'
  spec.add_runtime_dependency 'ms_rest', '~> 0.7.4'
end
