# frozen_string_literal: true

module IoMonitor
  module Controller
    extend ActiveSupport::Concern

    delegate :aggregator, to: IoMonitor

    ALL_ACTIONS = Object.new

    class_methods do
      def monitor_io_for(*actions_to_monitor_io)
        @actions_to_monitor_io = actions_to_monitor_io
      end

      def actions_to_monitor_io
        @actions_to_monitor_io || ALL_ACTIONS
      end
    end

    def process_action(*)
      if monitors_action?(action_name)
        aggregator.collect { super }
      else
        super
      end
    end

    def append_info_to_payload(payload)
      super

      return unless monitors_action?(action_name)

      data = payload[IoMonitor::NAMESPACE] = {}

      aggregator.sources.each do |source|
        data[source] = aggregator.get(source)
      end

      data[:response] = payload[:response].body.bytesize
    end

    private

    def monitors_action?(action_name)
      actions = self.class.actions_to_monitor_io
      actions == ALL_ACTIONS || actions.include?(action_name.to_sym)
    end
  end
end
