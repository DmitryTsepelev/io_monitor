require "active_support/core_ext/module/attr_internal"
require "active_record/log_subscriber"

module IoToResponsePayloadRatio
  module Railties # :nodoc:
    module ControllerDbAllocatedMemory #:nodoc:
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def log_process_action(payload)
          messages, db_allocated_memory = super, payload[:db_allocated_memory]
          messages << ("DB Payload: %.1fkb" % db_allocated_memory.to_f) if db_allocated_memory
          messages
        end
      end

      private

      attr_internal :db_allocated_memory

      def process_action(action, *args)
        ActiveRecord::LogSubscriber.reset_allocated_memory

        super
      end

      def append_info_to_payload(payload)
        super

        if ActiveRecord::Base.connected?
          payload[:db_allocated_memory] = (db_allocated_memory || 0) + ActiveRecord::LogSubscriber.reset_allocated_memory
        end
      end
    end
  end
end
