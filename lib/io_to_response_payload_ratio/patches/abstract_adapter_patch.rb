# frozen_string_literal: true

module IoToResponsePayloadRatio
  module AbstractAdapterPatch
    def build_result(*args, **kwargs, &block)
      ActiveRecordAdapter.aggregate_result rows: kwargs[:rows]

      super
    end
  end
end
