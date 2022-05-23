# frozen_string_literal: true

module IoMonitor
  module FutureResultPatch
    def result
      # @event_buffer is used to send ActiveSupport notifications related to async queries
      return super unless @event_buffer

      res = super
      ActiveRecordAdapter.aggregate_result rows: res.rows

      res
    end
  end
end
