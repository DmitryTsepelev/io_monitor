# frozen_string_literal: true

module IoToResponsePayloadRatio
  class Configuration
    PUBLISHERS = %i[logs notifications].freeze

    DEFAULT_PUBLISHER = :logs
    DEFAULT_WARN_THRESHOLD = 0.0

    def initialize
      @publish = DEFAULT_PUBLISHER
      @warn_threshold = DEFAULT_WARN_THRESHOLD
    end

    attr_reader :publish, :warn_threshold

    def publish=(value)
      if PUBLISHERS.include?(value)
        @publish = value
      else
        raise ArgumentError, "Only the following publishers are supported: #{PUBLISHERS}."
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
  end
end
