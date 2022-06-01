# frozen_string_literal: true

require "io_monitor/patches/action_controller_base_patch"

module IoMonitor
  class Railtie < Rails::Railtie
    config.after_initialize do
      IoMonitor.config.adapters.each(&:initialize!)

      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.singleton_class.prepend(ActionControllerBasePatch)
      end

      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
        payload = args.last[IoMonitor::NAMESPACE]
        next unless payload

        IoMonitor.config.publishers.each { |publisher| publisher.process_action(payload) }
      end
    end
  end
end
