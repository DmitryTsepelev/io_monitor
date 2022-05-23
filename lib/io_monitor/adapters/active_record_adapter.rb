# frozen_string_literal: true

require "io_monitor/patches/abstract_adapter_patch"
require "io_monitor/patches/future_result_patch"

module IoMonitor
  class ActiveRecordAdapter < BaseAdapter
    class << self
      def kind
        :active_record
      end

      def aggregate_result(rows:)
        return unless IoMonitor.aggregator.active?

        # `.flatten.join.bytesize` would look prettier,
        # but it makes a lot of unnecessary allocations.
        io_payload_size = rows.sum(0) do |row|
          row.sum(0) do |val|
            (String === val ? val : val.to_s).bytesize
          end
        end

        IoMonitor.aggregator.increment(kind, io_payload_size)
      end
    end

    def initialize!
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(AbstractAdapterPatch)

        if Rails::VERSION::MAJOR >= 7
          ActiveRecord::FutureResult.prepend(FutureResultPatch)
        end
      end
    end
  end
end
