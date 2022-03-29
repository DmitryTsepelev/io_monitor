# frozen_string_literal: true

module IoToResponsePayloadRatio
  module Controller
    extend ActiveSupport::Concern

    def append_info_to_payload(payload)
      input_payload = IoToResponsePayloadRatio::LogSubscriber.reset_input_payload

      super

      body_payload = payload[:response]&.body&.bytesize || 0
      payload[:io_to_response_payload_ratio] = {
        body_payload: body_payload,
        input_payload: input_payload
      }

      ActiveSupport::Notifications.instrument(
        'measurements.io_to_response_payload_ratio',
        body_payload: body_payload,
        input_payload: input_payload,
        controller_payload: payload
      )
    end
  end
end
