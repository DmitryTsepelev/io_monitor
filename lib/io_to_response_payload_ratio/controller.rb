require "io_to_response_payload_ratio/controller_runtime"

module IoToResponsePayloadRatio
  module Controller
    extend ActiveSupport::Concern

    def append_info_to_payload(payload)
      super

      if IoToResponsePayloadRatio.logs?
        payload[:io_to_response_payload_ratio] = {
          body_bytes: payload[:response]&.body&.bytesize || 0
        }
      end
    end
  end
end
