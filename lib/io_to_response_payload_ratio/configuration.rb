module IoToResponsePayloadRatio
  class Configuration
    attr_accessor :publish, :warn_threshold

    ALLOWED_PUBLISH_VALUES = %i[logs notifications]

    def initialize
      @publish = :logs
      @warn_threshold = 1.0
    end
  end
end
