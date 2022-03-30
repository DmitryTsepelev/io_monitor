# frozen_string_literal: true

require "filesize"

module IoToResponsePayloadRatio
  module ActionControllerBasePatch
    def log_process_action(payload)
      super.tap do |messages|
        next unless IoToResponsePayloadRatio.config.publish == :logs

        data = payload[IoToResponsePayloadRatio::NAMESPACE]
        next unless data

        data.each do |source, bytes|
          size = Filesize.from(bytes.to_s).pretty
          messages << "#{source.to_s.camelize} Payload: #{size}"
        end
      end
    end
  end
end
