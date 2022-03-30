# frozen_string_literal: true

require "io_to_response_payload_ratio/version"
require "io_to_response_payload_ratio/configuration"
require "io_to_response_payload_ratio/aggregator"
require "io_to_response_payload_ratio/controller"
require "io_to_response_payload_ratio/adapters/base_adapter"
require "io_to_response_payload_ratio/adapters/active_record_adapter"
require "io_to_response_payload_ratio/railtie"

module IoToResponsePayloadRatio
  ADAPTERS = [ActiveRecordAdapter].freeze
  NAMESPACE = :io_to_response_payload_ratio

  class << self
    def aggregator
      @aggregator ||= Aggregator.new(
        ADAPTERS.filter_map { |adapter| adapter.kind if adapter.enabled? }
      )
    end

    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end
end
