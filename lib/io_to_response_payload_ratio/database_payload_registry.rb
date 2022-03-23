require "fiber"

module IoToResponsePayloadRatio
  # Implementation from https://github.com/rails/rails/blob/main/activesupport/lib/active_support/isolated_execution_state.rb
  module IsolatedExecutionState
    @isolation_level = nil

    Thread.attr_accessor :io_to_response_payload_ratio_execution_state
    Fiber.attr_accessor :io_to_response_payload_ratio_execution_state

    class << self
      attr_reader :isolation_level, :scope

      def isolation_level=(level)
        return if level == @isolation_level

        unless %i[thread fiber].include?(level)
          raise ArgumentError, "isolation_level must be `:thread` or `:fiber`, got: `#{level.inspect}`"
        end

        clear if @isolation_level

        @scope = case level
          when :thread then Thread
          when :fiber then Fiber
        end

        @isolation_level = level
      end

      def unique_id
        self[:__id__] ||= Object.new
      end

      def [](key)
        state[key]
      end

      def []=(key, value)
        state[key] = value
      end

      def key?(key)
        state.key?(key)
      end

      def delete(key)
        state.delete(key)
      end

      def clear
        state.clear
      end

      def context
        scope.current
      end

      private

      def state
        context.io_to_response_payload_ratio_execution_state ||= {}
      end
    end

    self.isolation_level = :thread
  end

  module DatabasePayloadRegistry
    extend self

    def payload
      IsolatedExecutionState[:active_record_db_payload]
    end

    def payload=(payload)
      IsolatedExecutionState[:active_record_db_payload] = payload
    end
  end
end
