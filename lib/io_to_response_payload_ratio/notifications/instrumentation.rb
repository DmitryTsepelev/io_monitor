# frozen_string_literal: true

require_relative "base"

module IoToResponsePayloadRatio
  module Notifications
    class Instrumentation < Base
      INSTRUMENT_NAME = 'io_to_response_payload_ration.low_ratio'

      def call
        ActiveSupport::Notifications.instrument(INSTRUMENT_NAME, payload)
      end
    end
  end
end
