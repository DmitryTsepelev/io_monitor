# frozen_string_literal: true

module IoMonitor
  class BaseAdapter
    # :nocov:
    def self.kind
      raise NotImplementedError
    end

    def initialize!
      raise NotImplementedError
    end
    # :nocov:
  end
end
