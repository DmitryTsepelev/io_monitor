# frozen_string_literal: true

module IoMonitor
  module Controller
    extend ActiveSupport::Concern

    def process_action(*)
      IoMonitor.aggregator.start!

      super

      IoMonitor.aggregator.stop!
    end

    def append_info_to_payload(payload)
      super

      data = payload[IoMonitor::NAMESPACE] = {}

      IoMonitor.aggregator.sources.each do |source|
        data[source] = IoMonitor.aggregator.get(source)
      end

      data[:response] = payload[:response]&.body&.bytesize || 0
    end
  end
end
