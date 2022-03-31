# frozen_string_literal: true

require_relative "notifications/base"
require_relative "notifications/logs"
require_relative "notifications/instrumentation"

module IoToResponsePayloadRatio
  class Configuration
    attr_reader :available_notifications, :warn_threshold
    attr_accessor :publish

    DEFAULT_NOTIFICATIONS = {
      logs: Notifications::Logs,
      instrumentation: Notifications::Instrumentation
    }.freeze

    DEFAULT_NOTIFICATION = :logs
    MAX_THRESHOLD = 1.0
    MIN_THRESHOLD = 0.0

    def initialize
      @publish = :logs
      @warn_threshold = 1.0
      @available_notifications = DEFAULT_NOTIFICATIONS.dup
    end

    def warn_threshold=(value)
      value = value.to_f

      @warn_threshold =
        if value > 1.0
          MAX_THRESHOLD
        elsif value < 0
          MIN_THRESHOLD
        else
          value
        end
    end

    def add_notification(notifications)
      return unless notifications.is_a?(Hash)

      notifications.each do |key, performer_class|
        key = key.to_sym

        next if @available_notifications.key?(key) || !(performer_class < Notifications::Base)

        @available_notifications[key] = performer_class
      end
    end

    def current_notification
      available_notifications[publish] || available_notifications[DEFAULT_NOTIFICATION]
    end
  end
end
