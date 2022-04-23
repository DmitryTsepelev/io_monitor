# frozen_string_literal: true

require_relative "lib/io_to_response_payload_ratio/version"

Gem::Specification.new do |spec|
  spec.name = "io_to_response_payload_ratio"
  spec.version = IoToResponsePayloadRatio::VERSION
  spec.authors = ["baygeldin", "prog-supdex", "maxshend", "DmitryTsepelev"]
  spec.email = ["dmitry.a.tsepelev@gmail.com"]
  spec.homepage = "https://github.com/DmitryTsepelev/io_to_response_payload_ratio"
  spec.summary = "A gem that helps to detect potential memory bloats"

  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/DmitryTsepelev/io_to_response_payload_ratio/issues",
    "changelog_uri" => "https://github.com/DmitryTsepelev/io_to_response_payload_ratio/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://github.com/DmitryTsepelev/io_to_response_payload_ratio/blob/master/README.md",
    "homepage_uri" => "https://github.com/DmitryTsepelev/io_to_response_payload_ratio",
    "source_code_uri" => "https://github.com/DmitryTsepelev/io_to_response_payload_ratio"
  }

  spec.files = [
    Dir.glob("lib/**/*"),
    "README.md",
    "CHANGELOG.md",
    "LICENSE.txt"
  ].flatten

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  rails_version = ENV["RAILS_VERSION"] || ">= 6.0"
  spec.add_dependency "rails", rails_version
end
