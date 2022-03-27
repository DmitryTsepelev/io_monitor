module IoToResponsePayloadRatio
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.input_payload=(value)
      IoToResponsePayloadRatio::InputPayloadRegistry.payload = value
    end

    def self.input_payload
      IoToResponsePayloadRatio::InputPayloadRegistry.payload ||= 0
    end

    def self.reset_input_payload
      payload, self.input_payload = input_payload, 0
      payload
    end

    def db_result(event)
      self.class.input_payload += event.payload[:db_payload]
    end
  end
end

IoToResponsePayloadRatio::LogSubscriber.attach_to :io_to_response_payload_ratio
