require "action_controller"

module IoToResponsePayloadRatio
  module ActionControllerPatch
    class ::ActionController::Base
      def self.log_process_action(payload)
        custom_payload = payload[:io_to_response_payload_ratio]

        return super unless custom_payload

        messages, body_bytes, db_bytes = super, custom_payload[:body_bytes], custom_payload[:db_bytes]
        messages << "DB Payload: #{"%.2f" % (db_bytes / 1000.0)}kB"
        messages << "Body: #{"%.2f" % (body_bytes / 1000.0)}kB"
        messages
      end

      private

      attr_internal :db_bytes

      def process_action(action, *args)
        IoToResponsePayloadRatio::LogSubscriber.reset_db_payload
        super
      end
    end
  end
end
