# frozen_string_literal: true

module IoToResponsePayloadRatio
  module Controller
    extend ActiveSupport::Concern

    def process_action(*)
      IoToResponsePayloadRatio.aggregator.reset!
      IoToResponsePayloadRatio.aggregator.start!

      super

      IoToResponsePayloadRatio.aggregator.stop!
    end

    def append_info_to_payload(payload)
      super

      data = payload[IoToResponsePayloadRatio::NAMESPACE] = {}

      IoToResponsePayloadRatio.aggregator.sources.each do |source|
        data[source] = IoToResponsePayloadRatio.aggregator.get(source)
      end

      data[:response] = payload[:response]&.body&.bytesize || 0
    end
  end
end
