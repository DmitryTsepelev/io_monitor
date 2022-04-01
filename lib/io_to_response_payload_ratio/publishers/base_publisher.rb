# frozen_string_literal: true

module IoToResponsePayloadRatio
  class BasePublisher
    # :nocov:
    def self.kind
      raise NotImplementedError
    end

    def publish(source, ratio)
      raise NotImplementedError
    end
    # :nocov:

    def process_action(payload)
      (payload.keys - [:response]).each do |source|
        ratio = ratio(payload[:response], payload[source])

        if ratio < IoToResponsePayloadRatio.config.warn_threshold
          publish(source, ratio)
        end
      end
    end

    private

    def ratio(response_size, io_size)
      response_size.to_f / io_size.to_f
    end
  end
end
