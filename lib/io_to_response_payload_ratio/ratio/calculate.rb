# frozen_string_literal: true

module IoToResponsePayloadRatio
  module Ratio
    class Calculate
      POSITIVE_RATIO = 1

      attr_reader :ratio

      def initialize(response_payload_size:, source_payload_size:)
        @source_payload_size = source_payload_size.to_f
        @response_payload_size = response_payload_size.to_f
        @ratio = calculated_ratio
      end

      private

      attr_reader :response_payload_size, :source_payload_size

      def calculated_ratio
        puts 'BEFORE &&&&&&&&&&&&&&&&&&'
        puts 'BEFORE &&&&&&&&&&&&&&&&&&'
        puts 'BEFORE &&&&&&&&&&&&&&&&&&'
        puts 'BEFORE &&&&&&&&&&&&&&&&&&'
        puts "source_payload_size - #{source_payload_size}, response_payload_size - #{response_payload_size}"
        if source_payload_size.zero? && response_payload_size.zero?
          return POSITIVE_RATIO
        end

        if source_payload_size.zero?
          return POSITIVE_RATIO
        end

        puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

        response_payload_size / source_payload_size
      end
    end
  end
end
