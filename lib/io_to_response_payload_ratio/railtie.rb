require 'io_to_response_payload_ratio'
require 'io_to_response_payload_ratio/railties/controller_db_allocated_memory'
require 'rails/railtie'

module IoToResponsePayloadRatio
  class Railtie < Rails::Railtie
    initializer "io_to_response_payload_ratio.ar_measure_memory" do
      ActiveSupport.on_load(:action_controller) do
        include ::IoToResponsePayloadRatio::Railties::ControllerDbAllocatedMemory
      end
    end
  end
end
