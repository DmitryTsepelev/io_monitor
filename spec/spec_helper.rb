# frozen_string_literal: true

require "simplecov"
SimpleCov.start if ENV["COVERAGE"]

ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"

require "rspec/rails"

require "io_to_response_payload_ratio"

RSpec.configure do |config|
  # For proper work of ActiveSupport::CurrentAttributes reset
  config.include ActiveSupport::CurrentAttributes::TestHelper

  config.example_status_persistence_file_path = ".rspec_status"
  config.infer_base_class_for_anonymous_controllers = true

  config.extend WithModel

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
