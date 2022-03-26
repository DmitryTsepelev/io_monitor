# frozen_string_literal: true

require_relative "io_to_response_payload_ratio/configuration"
require_relative "io_to_response_payload_ratio/railtie"
require_relative "io_to_response_payload_ratio/measure_memory"
require_relative "io_to_response_payload_ratio/allocated_memory_registry"
require_relative "io_to_response_payload_ratio/extensions/process_action_with_response"
require_relative "io_to_response_payload_ratio/extensions/active_record/extension"

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
