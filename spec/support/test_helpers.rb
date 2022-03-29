# frozen_string_literal: true

require 'fileutils'

module TestHelpers
  def config_file
    "#{Rails.root}/config/io_to_response_payload_ratio.rb"
  end

  def remove_config
    FileUtils.remove_file config_file if File.file?(config_file)
  end

  def file_content(path)
    File.binread path
  end

  def json
    JSON.parse response.body
  end

  def products_attrs(count = 10)
    Array.new(count) { |i| { id: i, name: i.to_s } }
  end

  def controller_route_name(controller)
    controller.class.name.underscore.split('_')[0...-1].join('_')
  end

  def setup_log_subscriber(logger)
    allow_any_instance_of(IoToResponsePayloadRatio::LogSubscriber).to receive(:logger).and_return logger
  end
end
