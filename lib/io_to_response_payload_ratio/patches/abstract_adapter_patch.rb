# frozen_string_literal: true

module IoToResponsePayloadRatio
  module AbstractAdapterPatch
    def build_result(*args, **kwargs, &block)
      if IoToResponsePayloadRatio.aggregator.active?
        # `.flatten.join.bytesize` would look prettier,
        # but it makes a lot of unnecessary allocations.
        io_payload_size = kwargs[:rows].sum(0) do |row|
          row.sum(0) do |val|
            (String === val ? val : val.to_s).bytesize
          end
        end

        IoToResponsePayloadRatio.aggregator
          .increment(ActiveRecordAdapter.kind, io_payload_size)
      end

      super
    end
  end
end
