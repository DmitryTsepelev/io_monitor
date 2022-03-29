# frozen_string_literal: true

module IoToResponsePayloadRatio
  module Ratio
    class Calculate
      MAX_POSITIVE_RATIO = 1

      attr_reader :ratio

      def initialize(response_payload_size:, source_payload_size:)
        @source_payload_size = source_payload_size.to_f
        @response_payload_size = response_payload_size.to_f
        @ratio = calculated_ratio
      end

      private

      attr_reader :response_payload_size, :source_payload_size

      def calculated_ratio
        if source_payload_size.zero? && response_payload_size.zero?
          return MAX_POSITIVE_RATIO
        end

        if source_payload_size.zero?
          return MAX_POSITIVE_RATIO
        end

        result = response_payload_size / source_payload_size

        result = MAX_POSITIVE_RATIO if result > MAX_POSITIVE_RATIO

        result
      end
    end
  end
end
