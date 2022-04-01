# frozen_string_literal: true

module IoToResponsePayloadRatio
  class LogsPublisher < BasePublisher
    def self.kind
      :logs
    end

    def publish(source, ratio)
      Rails.logger.warn <<~HEREDOC.squish
        #{source.to_s.camelize} I/O to response payload ratio is #{ratio},
        while threshold is #{IoToResponsePayloadRatio.config.warn_threshold}
      HEREDOC
    end
  end
end
