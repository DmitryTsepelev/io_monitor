module IoToResponsePayloadRatio
  module Notifications
    class Base
      INSTRUMENT_NAME = 'ratio'
      MESSAGE = 'I/O to response payload ratio is __ratio__, while threshold is __config_ratio__'

      attr_reader :payload, :ratio, :configuration

      def initialize(payload:, ratio:)
        @payload = payload
        @ratio = ratio.to_f
        @configuration = IoToResponsePayloadRatio.configuration
      end

      def call
        raise NotImplementedError, "This class #{self.class} cannot response to:"
      end
    end
  end
end
