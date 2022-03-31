# frozen_string_literal: true

require "active_support/core_ext/module/attr_internal"
require "active_record/log_subscriber"

module IoToResponsePayloadRatio
  module Railties # :nodoc:
    module ControllerDbPayloadSize # :nodoc:
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        def log_process_action(payload)
          messages, db_payload_size = super, payload[:db_payload_size]
          messages << ("DB Payload: %.1fkb" % db_payload_size.to_f) if db_payload_size
          messages
        end
      end

      private

      attr_internal :db_payload_size

      def process_action(action, *args)
        ActiveRecord::LogSubscriber.reset_db_payload_size

        super
      end

      def append_info_to_payload(payload)
        super

        if ActiveRecord::Base.connected?
          payload[:db_payload_size] = (db_payload_size || 0) + ActiveRecord::LogSubscriber.reset_db_payload_size
        end
      end
    end
  end
end
