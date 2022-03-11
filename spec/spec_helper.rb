# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "spec/"
end

if ENV["CI"] == "true"
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require "io_to_response_payload_ratio"

ENV["RAILS_ENV"] = "test"

require_relative "./dummy/config/environment"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  config.include TestHelpers
end
