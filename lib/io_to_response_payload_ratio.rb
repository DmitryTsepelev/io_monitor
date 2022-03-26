# frozen_string_literal: true

require_relative "io_to_response_payload_ratio/configuration"
require_relative "io_to_response_payload_ratio/railtie"
require_relative "io_to_response_payload_ratio/measure_memory"
require_relative "io_to_response_payload_ratio/allocated_memory_registry"
require_relative "io_to_response_payload_ratio/db/measure"
require_relative "io_to_response_payload_ratio/extensions/process_action_with_response"

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

  module Controller

  end
end

class << ActiveRecord::LogSubscriber
  def db_payload_size
    IoToResponsePayloadRatio::AllocatedMemoryRegistry.db_payload_size ||= 0
  end

  def append_db_payload_size=(value)
    self.db_payload_size = db_payload_size + value
  end

  def db_payload_size=(value)
    IoToResponsePayloadRatio::AllocatedMemoryRegistry.db_payload_size = value
  end

  def reset_allocated_memory
    rt, self.allocated_memory = allocated_memory, 0
    rt
  end
end

ActiveRecord::Relation.send(:prepend, IoToResponsePayloadRatio::DB::Measure)
