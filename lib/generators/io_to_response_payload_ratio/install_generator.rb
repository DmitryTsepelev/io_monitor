# frozen_string_literal: true

require 'rails/generators'

module IoToResponsePayloadRatio
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      def copy_config
        template 'io_to_response_payload_ratio_config.rb', "#{Rails.root}/config/io_to_response_payload_ratio.rb"
      end
    end
  end
end
