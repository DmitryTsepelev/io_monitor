# frozen_string_literal: true

module IoMonitor
  class Configuration
    DEFAULT_WARN_THRESHOLD = 0.0

    def initialize
      @publishers = [LogsPublisher.new]
      @adapters = [ActiveRecordAdapter.new]
      @warn_threshold = DEFAULT_WARN_THRESHOLD
    end

    attr_reader :publishers, :adapters, :warn_threshold

    def publish=(values)
      @publishers = [*values].map { |value| value_to_publisher(value) }
    end

    def adapters=(value)
      @adapters = [*value].map do |adapter|
        if adapter.is_a?(BaseAdapter)
          adapter
        elsif (adapter_type = resolve(IoMonitor::ADAPTERS, adapter))
          adapter_type.new
        else
          supported = IoMonitor::ADAPTERS.map(&:kind)
          raise ArgumentError, "Only the following adapters are supported: #{supported}."
        end
      end
    end

    def warn_threshold=(value)
      case value
      when 0..1
        @warn_threshold = value.to_f
      else
        raise ArgumentError, "Warn threshold should be within 0..1 range."
      end
    end

    private

    def resolve(list, kind)
      list.find { |p| p.kind == kind }
    end

    def value_to_publisher(value)
      if value.is_a?(BasePublisher)
        value
      elsif (publisher_type = resolve(IoMonitor::PUBLISHERS, value))
        publisher_type.new
      else
        supported = IoMonitor::PUBLISHERS.map(&:kind)
        raise ArgumentError, "Only the following publishers are supported: #{supported}."
      end
    end
  end
end
