# frozen_string_literal: true

module Helpers
  module AsyncHelper
    def wait_for_async_query(relation, timeout: 5)
      if !relation.connection.async_enabled? || relation.instance_variable_get(:@records)
        raise ArgumentError, "async hasn't been enabled or used"
      end

      future_result = relation.instance_variable_get(:@future_result)
      (timeout * 100).times do
        return relation unless future_result.pending?
        sleep 0.01
      end

      raise Timeout::Error, "The async executor wasn't drained after #{timeout} seconds"
    end
  end
end
