require "active_record"

module IoToResponsePayloadRatio
  module ActiveRecordPatch
    module ::ActiveRecord
      module ConnectionAdapters
        class SQLite3Adapter < AbstractAdapter
          def build_result(**args)
            objs = super
            payload_size = args[:columns].join.bytesize + args[:rows].map(&:join).join.bytesize
            ActiveSupport::Notifications.instrument(
              "db_result.io_to_response_payload_ratio",
              db_payload: payload_size
            )

            objs
          end
        end
      end
    end
  end
end
