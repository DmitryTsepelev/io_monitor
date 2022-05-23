# frozen_string_literal: true

require "io_monitor/version"
require "io_monitor/configuration"
require "io_monitor/aggregator"
require "io_monitor/controller"

require "io_monitor/adapters/base_adapter"
require "io_monitor/adapters/active_record_adapter"
require "io_monitor/adapters/net_http_adapter"

require "io_monitor/publishers/base_publisher"
require "io_monitor/publishers/logs_publisher"
require "io_monitor/publishers/notifications_publisher"

require "io_monitor/railtie"

module IoMonitor
  NAMESPACE = :io_monitor
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
