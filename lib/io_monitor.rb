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
require "io_monitor/publishers/prometheus_publisher"

require "io_monitor/railtie"

module IoMonitor
  NAMESPACE = :io_monitor

  adapters = [ActiveRecordAdapter, NetHttpAdapter]

  if defined? Redis
    require "io_monitor/adapters/redis_adapter"
    adapters << RedisAdapter
  end
  ADAPTERS = adapters.freeze

  PUBLISHERS = [LogsPublisher, NotificationsPublisher, PrometheusPublisher].freeze

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
