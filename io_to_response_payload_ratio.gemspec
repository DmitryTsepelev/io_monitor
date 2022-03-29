# frozen_string_literal: true

require_relative 'lib/io_to_response_payload_ratio/version'

Gem::Specification.new do |spec|
  spec.name = 'io_to_response_payload_ratio'
  spec.version = IoToResponsePayloadRatio::VERSION
  spec.authors = ['DmitryTsepelev']
  spec.email = ['dmitry.a.tsepelev@gmail.com']

  spec.summary = 'Will add later.'
  spec.description = 'Will add later.'
  spec.homepage = 'https://github.com/DmitryTsepelev/io_to_response_payload_ratio'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/DmitryTsepelev/io_to_response_payload_ratio',
    'changelog_uri' => 'https://github.com/DmitryTsepelev/io_to_response_payload_ratio/blob/main/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/DmitryTsepelev/io_to_response_payload_ratio/issues',
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir['lib/**/*'] + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ['lib']

  rails_version = ENV['TEST_RAILS_VERSION'] || '>= 6.0'
  spec.add_dependency 'rails', rails_version

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails', '>= 3.4'
  spec.add_development_dependency 'rubocop-performance', '~> 1.12'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'simplecov-cobertura', '~> 2.0.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4.2'
end
