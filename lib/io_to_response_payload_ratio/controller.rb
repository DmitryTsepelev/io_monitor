module IoToResponsePayloadRatio
  module Controller
    extend ActiveSupport::Concern

    def append_info_to_payload(payload)
      super

      if IoToResponsePayloadRatio.logs?
        payload[:io_to_response_payload_ratio] = {
          body_bytes: payload[:response]&.body&.bytesize || 0,
          db_bytes: (db_bytes || 0) + IoToResponsePayloadRatio::LogSubscriber.reset_db_payload
        }
      end
    end
  end
end
