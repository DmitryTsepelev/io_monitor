# frozen_string_literal: true

require_relative "../resolver"
require_relative '../../ratio/calculate'

module IoToResponsePayloadRatio
  module Notifications
    module ActiveRecord
      class Notification
        attr_reader :payload, :ratio

        def initialize(payload)
          @payload = payload[:payload]
          @ratio =
            IoToResponsePayloadRatio::Ratio::Calculate.new(
              response_payload_size: @payload[:response_payload_size],
              source_payload_size: @payload[:db_payload_size]
            ).ratio
        end

        def call
          Resolver.new(payload: payload, ratio: ratio).call
        end
      end
    end
  end
end
