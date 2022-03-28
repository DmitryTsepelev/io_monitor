# frozen_string_literal: true

require_relative "instrumentation"
require_relative "logs"
require_relative "active_record/notification"

module IoToResponsePayloadRatio
  module Notifications
    class Resolver
      INSTRUMENT_NAME = 'ratio'
      MESSAGE = 'I/O to response payload ratio is _ratio_, while threshold is _threshold_'

      attr_reader :payload, :ratio, :configuration

      def initialize(payload:, ratio:)
        @payload = payload || {}
        @ratio = ratio.to_f
        @configuration = IoToResponsePayloadRatio.configuration
      end

      def call
        return if ratio >= configuration.warn_threshold

        payload[:ratio_message] = build_message

        notification_by_type(configuration.publish).new(payload: payload, ratio: ratio).call
      end

      private

      def notification_by_type(publish_type)
        "IoToResponsePayloadRatio::Notifications::#{publish_type.to_s.camelize}".constantize
      end

      def build_message
        MESSAGE.gsub(/_ratio_|_threshold_/, '_ratio_' => ratio, '_threshold_' => configuration.warn_threshold)
      end
    end
  end
end
