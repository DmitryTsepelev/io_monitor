# frozen_string_literal: true

require "io_to_response_payload_ratio/patches/abstract_adapter_patch"

module IoToResponsePayloadRatio
  class ActiveRecordAdapter < BaseAdapter
    class << self
      def kind
        :active_record
      end

      def enabled?
        true
      end

      def initialize!
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend(AbstractAdapterPatch)
        end
      end
    end
  end
end
