# frozen_string_literal: true

require_relative "io_to_response_payload_ratio/version"
require_relative "io_to_response_payload_ratio/controller_runtime"

module IoToResponsePayloadRatio
  class Error < StandardError; end

  include ControllerRuntime

  PUBLISH_OPTIONS = %i[logs notifications].freeze

  class << self
    attr_reader :warn_threshold, :publish

    def warn_threshold=(threshold)
      if threshold < 0 || threshold > 1
        raise ArgumentError, "Invalid threshold value. Expecting threshold in the range [0, 1]."
      end

      @warn_threshold = threshold
    end

    def publish=(option)
      unless PUBLISH_OPTIONS.include? option
        raise ArgumentError, "Unknown publish option `#{option.inspect}`. Expecting #{PUBLISH_OPTIONS.map(&:inspect).join(", ")}"
      end

      @publish = option
    end

    def configure
      yield self
    end

    def logs?
      publish == :logs
    end

    def notifications?
      publish == :notifications
    end
  end

  self.warn_threshold = 0.5
  self.publish = PUBLISH_OPTIONS.first
end
