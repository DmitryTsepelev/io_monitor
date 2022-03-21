require "action_controller"

module IoToResponsePayloadRatio
  module ControllerRuntime
    class ::ActionController::Base
      def self.log_process_action(payload)
        custom_payload = payload[:io_to_response_payload_ratio]

        return super unless custom_payload

        messages, body_bytes = super, custom_payload[:body_bytes]
        messages << "Body: #{"%.2f" % (body_bytes / 1000.0)}kB"
        messages
      end
    end
  end
end
