# frozen_string_literal: true

require "active_support/core_ext/module/attr_internal"
require "active_record/log_subscriber"

module IoToResponsePayloadRatio
  module Railties # :nodoc:
    module ControllerResponsePayloadSize #:nodoc:
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def log_process_action(payload)
          messages, response_payload_size = super, payload[:response_payload_size]
          messages << ("Body Payload: %.1fkb" % response_payload_size.to_f) if response_payload_size
          messages
        end
      end

      private

      attr_internal :response_payload_size

      def append_info_to_payload(payload)
        super

        if ActiveRecord::Base.connected?
          payload[:response_payload_size] = response_payload_size || 0
        end
      end

      # Check for rendering json
      def render(*args)
        return super if !args.is_a?(Array) || !args[0].is_a?(Hash)

        data = args[0]

        return super unless data.key?(:json)

        self.response_payload_size =
          IoToResponsePayloadRatio::MeasurePayloadSize.new(data[:json]).payload_size_in_kb

        super
      end
    end
  end
end
