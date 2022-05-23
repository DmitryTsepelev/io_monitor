# frozen_string_literal: true

module IoMonitor
  class NotificationsPublisher < BasePublisher
    WARN_THRESHOLD_REACHED_EVENT = "warn_threshold_reached"

    def self.kind
      :notifications
    end

    def publish(source, ratio)
      ActiveSupport::Notifications.instrument(
        full_event_name(WARN_THRESHOLD_REACHED_EVENT),
        source: source,
        ratio: ratio
      )
    end

    private

    def full_event_name(event_name)
      "#{event_name}.#{IoMonitor::NAMESPACE}"
    end
  end
end
