# frozen_string_literal: true

require 'io_to_response_payload_ratio/railties/controller_db_payload_size'
require 'io_to_response_payload_ratio/railties/controller_response_payload_size'
require 'rails/railtie'

module IoToResponsePayloadRatio
  class Railtie < Rails::Railtie
    initializer "io_to_response_payload_ratio.measure_payload" do
      ActiveSupport.on_load(:action_controller) do
        include ::IoToResponsePayloadRatio::Railties::ControllerDbPayloadSize
        include ::IoToResponsePayloadRatio::Railties::ControllerResponsePayloadSize
      end
    end
  end
end
