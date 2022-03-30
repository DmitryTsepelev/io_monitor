# frozen_string_literal: true

module IoToResponsePayloadRatio
  class Notifier < ActiveSupport::Subscriber
    WARN_THRESHOLD_REACHED_EVENT = "warn_threshold_reached"

    attach_to :action_controller

    def process_action(event)
      return unless relevant?(event)

      data = event.payload[IoToResponsePayloadRatio::NAMESPACE]

      (data.keys - [:response]).each do |source|
        ratio = ratio(data, source)

        if ratio < warn_threshold
          notify(data, source, ratio)
        end
      end
    end

    private

    def relevant?(event)
      !!event.payload[IoToResponsePayloadRatio::NAMESPACE]
    end

    def ratio(data, source)
      data[:response].to_f / data[source].to_f
    end

    def warn_threshold
      IoToResponsePayloadRatio.config.warn_threshold
    end

    def notify(data, source, ratio)
      case IoToResponsePayloadRatio.config.publish
      when :logs
        Rails.logger.warn <<~HEREDOC.squish
          #{source.to_s.camelize} I/O to response payload ratio is #{ratio},
          while threshold is #{warn_threshold}
        HEREDOC
      when :notifications
        ActiveSupport::Notifications.instrument(
          full_event_name(WARN_THRESHOLD_REACHED_EVENT),
          source: source,
          ratio: ratio
        )
      end
    end

    def full_event_name(event_name)
      "#{event_name}.#{IoToResponsePayloadRatio::NAMESPACE}"
    end
  end
end
