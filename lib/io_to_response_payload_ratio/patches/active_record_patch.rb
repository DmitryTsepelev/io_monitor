require "active_record"

module IoToResponsePayloadRatio
  module ActiveRecordPatch
    module CustomResultMethod
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

    module ::ActiveRecord
      module ConnectionAdapters
        class SQLite3Adapter < AbstractAdapter
          include CustomResultMethod
        end

        class PostgreSQLAdapter < AbstractAdapter
          include CustomResultMethod
        end

        class Mysql2Adapter
          include CustomResultMethod
        end
      end
    end
  end
end
