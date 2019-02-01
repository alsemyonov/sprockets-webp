# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sprockets/webp/version'

Gem::Specification.new do |spec|
  spec.name = 'sprockets-webp-exporter'
  spec.version = Sprockets::WebP::VERSION
  spec.authors = ['Alex Semyonov']
  spec.email = ['alex@semyonov.us']
  spec.summary = %q{Sprockets 4 exporter of PNG and JPEG assets to WebP}
  spec.description = spec.summary
  spec.homepage = 'https://github.com/alsemyonov/sprockets-webp-exporter'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'sprockets', '>= 4.0.0.beta8'
  spec.add_dependency 'webp-ffi', '0.2.5'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
