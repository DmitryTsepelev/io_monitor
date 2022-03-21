# frozen_string_literal: true

require_relative "io_to_response_payload_ratio/configuration"
require_relative "io_to_response_payload_ratio/railtie"
require_relative "io_to_response_payload_ratio/measure_memory"
require_relative "io_to_response_payload_ratio/allocated_memory_registry"
require_relative "io_to_response_payload_ratio/db/measure"

module IoToResponsePayloadRatio
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

class << ActiveRecord::LogSubscriber
  def allocated_memory
    IoToResponsePayloadRatio::AllocatedMemoryRegistry.db_allocated_memory ||= 0
  end

  def allocated_memory=(value)
    IoToResponsePayloadRatio::AllocatedMemoryRegistry.db_allocated_memory ||= 0
    IoToResponsePayloadRatio::AllocatedMemoryRegistry.db_allocated_memory += value
  end

  def reset_allocated_memory
    rt, self.allocated_memory = allocated_memory, 0
    rt
  end
end

ActiveRecord::Relation.send(:prepend, IoToResponsePayloadRatio::DB::Measure)
