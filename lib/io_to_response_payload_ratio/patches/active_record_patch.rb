module IoToResponsePayloadRatio
  module ActiveRecordPatch
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

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.include IoToResponsePayloadRatio::ActiveRecordPatch
end

ActiveSupport::Notifications.subscribe("!connection.active_record") do
  if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include IoToResponsePayloadRatio::ActiveRecordPatch
  end

  if defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
    ActiveRecord::ConnectionAdapters::Mysql2Adapter.include IoToResponsePayloadRatio::ActiveRecordPatch
  end
end
