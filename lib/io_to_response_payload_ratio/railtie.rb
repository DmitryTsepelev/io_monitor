# frozen_string_literal: true

require "io_to_response_payload_ratio/patches/action_controller_base_patch"

module IoToResponsePayloadRatio
  class Railtie < Rails::Railtie
    config.after_initialize do
      IoToResponsePayloadRatio::ADAPTERS.each do |adapter|
        adapter.initialize! if adapter.enabled?
      end

      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.singleton_class.prepend(ActionControllerBasePatch)

        require "io_to_response_payload_ratio/notifier"
      end
    end
  end
end
