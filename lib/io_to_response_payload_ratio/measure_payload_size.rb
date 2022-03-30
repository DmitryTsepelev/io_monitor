# frozen_string_literal: true

module IoToResponsePayloadRatio
  class MeasurePayloadSize
    attr_accessor :result, :payload_bytes

    def initialize(data = nil)
      self.result =
        if block_given?
          yield
        else
          data
        end

      self.payload_bytes = Marshal.dump(result).size
    end

    def payload_size_in_bytes
      payload_bytes
    end

    def payload_size_in_kb
      (payload_bytes.to_f / 1024).round(2)
    end
  end
end
