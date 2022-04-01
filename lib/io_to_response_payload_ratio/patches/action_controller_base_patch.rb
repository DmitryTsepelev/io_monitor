# frozen_string_literal: true

module IoToResponsePayloadRatio
  module ActionControllerBasePatch
    def log_process_action(payload)
      super.tap do |messages|
        next unless IoToResponsePayloadRatio.config.publisher.is_a?(LogsPublisher)

        data = payload[IoToResponsePayloadRatio::NAMESPACE]
        next unless data

        data.each do |source, bytes|
          size = ActiveSupport::NumberHelper.number_to_human_size(bytes)
          messages << "#{source.to_s.camelize} Payload: #{size}"
        end
      end
    end
  end
end
