# frozen_string_literal: true

module IoToResponsePayloadRatio
  # :nocov:

  class BaseAdapter
    class << self
      def kind
        raise NotImplementedError
      end

      def enabled?
        raise NotImplementedError
      end

      def initialize!
        raise NotImplementedError
      end
    end
  end

  # :nocov:
end
