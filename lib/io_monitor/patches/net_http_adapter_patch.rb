# frozen_string_literal: true

module IoMonitor
  module NetHttpAdapterPatch
    def request(*args, &block)
      super do |response|
        if response.body && IoMonitor.aggregator.active?
          IoMonitor.aggregator.increment(NetHttpAdapter.kind, response.body.bytesize)
        end
      end
    end
  end
end
