# frozen_string_literal: true

module IoToResponsePayloadRatio
  module ActionControllerPatch
    extend ActiveSupport::Concern

    module ClassMethods
      def log_process_action(payload)
        custom_payload = payload[:io_to_response_payload_ratio]

        return super unless custom_payload

        messages = super
        body_payload = custom_payload[:body_payload]
        input_payload = custom_payload[:input_payload]

        if IoToResponsePayloadRatio.logs?
          messages << "Input Payload: #{format('%.3f', (input_payload / 1000.0))}kB"
          messages << "Body: #{format('%.3f', (body_payload / 1000.0))}kB"
        end

        messages
      end
    end
  end

  module ProcessActionPatch
    def process_action(action, *args)
      IoToResponsePayloadRatio::LogSubscriber.reset_input_payload
      super
    end

    def append_info_to_payload(payload)
      super
      IoToResponsePayloadRatio::LogSubscriber.reset_input_payload
    end
  end
end

ActiveSupport.on_load(:action_controller_api) do
  ActionController::API.include IoToResponsePayloadRatio::ProcessActionPatch
end

ActiveSupport.on_load(:action_controller_base) do
  ActionController::Base.include(
    IoToResponsePayloadRatio::ActionControllerPatch,
    IoToResponsePayloadRatio::ProcessActionPatch
  )
end
