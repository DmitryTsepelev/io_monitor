# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.root = File.join(__dir__, "..")
    config.logger = Logger.new("/dev/null")
    config.api_only = true
    config.active_record.legacy_connection_handling = false
  end
end
