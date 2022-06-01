# frozen_string_literal: true

module IoMonitor
  module ActionControllerBasePatch
    def log_process_action(payload)
      super.tap do |messages|
        next unless IoMonitor.config.publishers.any? { |publisher| publisher.is_a?(LogsPublisher) }

        data = payload[IoMonitor::NAMESPACE]
        next unless data

        data.each do |source, bytes|
          size = ActiveSupport::NumberHelper.number_to_human_size(bytes)
          messages << "#{source.to_s.camelize} Payload: #{size}"
        end
      end
    end
  end
end
