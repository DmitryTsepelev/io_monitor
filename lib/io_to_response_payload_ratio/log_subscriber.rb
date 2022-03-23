module IoToResponsePayloadRatio
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.db_payload=(value)
      IoToResponsePayloadRatio::DatabasePayloadRegistry.payload = value
    end

    def self.db_payload
      IoToResponsePayloadRatio::DatabasePayloadRegistry.payload ||= 0
    end

    def self.reset_db_payload
      dout, self.db_payload = db_payload, 0
      dout
    end

    def db_result(event)
      self.class.db_payload += event.payload[:db_payload]
    end
  end
end

IoToResponsePayloadRatio::LogSubscriber.attach_to :io_to_response_payload_ratio
