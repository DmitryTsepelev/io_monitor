# frozen_string_literal: true

require "io_to_response_payload_ratio/version"
require "io_to_response_payload_ratio/configuration"
require "io_to_response_payload_ratio/aggregator"
require "io_to_response_payload_ratio/controller"

require "io_to_response_payload_ratio/adapters/base_adapter"
require "io_to_response_payload_ratio/adapters/active_record_adapter"
require "io_to_response_payload_ratio/adapters/net_http_adapter"

require "io_to_response_payload_ratio/publishers/base_publisher"
require "io_to_response_payload_ratio/publishers/logs_publisher"
require "io_to_response_payload_ratio/publishers/notifications_publisher"

require "io_to_response_payload_ratio/railtie"

module IoToResponsePayloadRatio
  NAMESPACE = :io_to_response_payload_ratio
  ADAPTERS = [ActiveRecordAdapter, NetHttpAdapter].freeze
  PUBLISHERS = [LogsPublisher, NotificationsPublisher].freeze

  class << self
    def aggregator
      @aggregator ||= Aggregator.new(
        config.adapters.map { |a| a.class.kind }
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
