# frozen_string_literal: true

require_relative "io_to_response_payload_ratio/configuration"
require_relative "io_to_response_payload_ratio/measure_payload_size"
require_relative "io_to_response_payload_ratio/railtie"
require_relative "io_to_response_payload_ratio/extensions/active_record/extension"
require_relative "io_to_response_payload_ratio/notifications/resolver"

module IoToResponsePayloadRatio
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    def notifications
      configuration.available_notifications
    end
  end

  module Controller
    def self.included(base)
      return unless base < ActionController::Base

      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)

        break if event.payload[:controller] != base.to_s

        Notifications::ActiveRecord::Notification.new(payload: event.payload).call
      end
    end
  end
end
