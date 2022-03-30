# frozen_string_literal: true

require "io_to_response_payload_ratio/patches/action_controller_base_patch"

module IoToResponsePayloadRatio
  class Railtie < Rails::Railtie
    config.after_initialize do
      IoToResponsePayloadRatio.config.adapters.each(&:initialize!)

      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.singleton_class.prepend(ActionControllerBasePatch)
      end

      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
        payload = args.last[IoToResponsePayloadRatio::NAMESPACE]
        next unless payload

        IoToResponsePayloadRatio.config.publisher.process_action(payload)
      end
    end
  end
end
