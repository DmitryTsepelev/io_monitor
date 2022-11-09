# frozen_string_literal: true

module IoMonitor
  class PrometheusPublisher < BasePublisher
    HELP_MESSAGE = "IO payload size to response payload size ratio"

    def initialize(registry: nil, aggregation: nil, buckets: nil)
      registry ||= ::Prometheus::Client.registry
      @metric = registry.histogram(
        "#{IoMonitor::NAMESPACE}_ratio".to_sym,
        labels: %i[adapter],
        buckets: buckets || ::Prometheus::Client::Histogram::DEFAULT_BUCKETS,
        store_settings: store_settings(aggregation),
        docstring: HELP_MESSAGE
      )
    end

    def self.kind
      :prometheus
    end

    def publish(source, ratio)
      metric.observe(ratio, labels: {adapter: source})
    end

    private

    attr_reader :metric

    # From https://github.com/yabeda-rb/yabeda-prometheus/blob/v0.8.0/lib/yabeda/prometheus/adapter.rb#L101
    def store_settings(aggregation)
      case ::Prometheus::Client.config.data_store
      when ::Prometheus::Client::DataStores::Synchronized, ::Prometheus::Client::DataStores::SingleThreaded
        {} # Default synchronized store doesn't allow to pass any options
      when ::Prometheus::Client::DataStores::DirectFileStore, ::Object # Anything else
        {aggregation: aggregation}.compact
      end
    end
  end
end
