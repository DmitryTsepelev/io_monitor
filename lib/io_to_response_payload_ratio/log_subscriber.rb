# frozen_string_literal: true

module IoToResponsePayloadRatio
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.input_payload=(value)
      IoToResponsePayloadRatio::InputPayloadRegistry.payload = value
    end

    def self.input_payload
      IoToResponsePayloadRatio::InputPayloadRegistry.payload ||= 0
    end

    def self.reset_input_payload
      payload = input_payload
      self.input_payload = 0
      payload
    end

    def db_result(event)
      self.class.input_payload += event.payload[:db_payload]
    end

    def measurements(event)
      input, body = event.payload.values_at :input_payload, :body_payload

      IoToResponsePayloadRatio.check_threshold logger: logger, input: input, body: body
    end
  end
end

IoToResponsePayloadRatio::LogSubscriber.attach_to :io_to_response_payload_ratio
