# frozen_string_literal: true

require_relative "base"

module IoToResponsePayloadRatio
  module Notifications
    class Logs < Base
      def call
        Rails.logger.warn(build_message)
      end

      private

      def build_message
        "#{payload[:ratio_message]}. #{payload[:controller]}##{payload[:action]}"
      end
    end
  end
end
