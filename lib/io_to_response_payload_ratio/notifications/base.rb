module IoToResponsePayloadRatio
  module Notifications
    class Base
      INSTRUMENT_NAME = 'ratio'
      MESSAGE = 'I/O to response payload ratio is __ratio__, while threshold is __config_ratio__'

      attr_reader :payload, :ratio, :configuration

      def initialize(payload:, ratio:)
        @payload = payload.presence || {}
        @ratio = ratio.to_f
        @configuration = IoToResponsePayloadRatio.configuration
      end

      def call
        return if ratio >= configuration.warn_threshold
        
        payload[:ratio_message] = MESSAGE.gsub()
        
        ActiveSupport::Notifications.instrument(@name, env)
      end
    end
  end
end
