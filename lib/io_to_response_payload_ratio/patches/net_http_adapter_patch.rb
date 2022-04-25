# frozen_string_literal: true

module IoToResponsePayloadRatio
  module NetHttpAdapterPatch
    def request(*args, &block)
      super do |response|
        if response.body && IoToResponsePayloadRatio.aggregator.active?
          IoToResponsePayloadRatio.aggregator.increment(NetHttpAdapter.kind, response.body.bytesize)
        end
      end
    end
  end
end
