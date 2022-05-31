# frozen_string_literal: true

require_relative "lib/io_monitor/version"

Gem::Specification.new do |spec|
  spec.name = "io_monitor"
  spec.version = IoMonitor::VERSION
  spec.authors = ["baygeldin", "prog-supdex", "maxshend", "DmitryTsepelev"]
  spec.email = ["dmitry.a.tsepelev@gmail.com"]
  spec.homepage = "https://github.com/DmitryTsepelev/io_monitor"
  spec.summary = "A gem that helps to detect potential memory bloats"

  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/DmitryTsepelev/io_monitor/issues",
    "changelog_uri" => "https://github.com/DmitryTsepelev/io_monitor/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://github.com/DmitryTsepelev/io_monitor/blob/master/README.md",
    "homepage_uri" => "https://github.com/DmitryTsepelev/io_monitor",
    "source_code_uri" => "https://github.com/DmitryTsepelev/io_monitor"
  }

  spec.files = [
    Dir.glob("lib/**/*"),
    "README.md",
    "CHANGELOG.md",
    "LICENSE.txt"
  ].flatten

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "rails", ">= 6.1"
  spec.add_development_dependency "redis", ">= 4.0"
end
