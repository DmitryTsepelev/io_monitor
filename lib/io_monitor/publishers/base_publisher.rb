# frozen_string_literal: true

module IoMonitor
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

        publish(source, ratio) if ratio < IoMonitor.config.warn_threshold
      end
    end

    private

    def ratio(response_size, io_size)
      return 0 if io_size.to_f.zero?

      response_size.to_f / io_size.to_f
    end
  end
end
