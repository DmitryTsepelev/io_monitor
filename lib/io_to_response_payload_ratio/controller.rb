module IoToResponsePayloadRatio
  module Controller
    extend ActiveSupport::Concern

    def append_info_to_payload(payload)
      super

      payload[:io_to_response_payload_ratio] = {
        body_payload: payload[:response]&.body&.bytesize || 0,
        input_payload: (input_payload || 0) + IoToResponsePayloadRatio::LogSubscriber.reset_input_payload
      }
    end
  end
end
