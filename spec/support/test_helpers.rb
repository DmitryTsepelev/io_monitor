require "fileutils"

module TestHelpers
  def config_file
    "#{Rails.root}/config/io_to_response_payload_ratio.rb"
  end

  def remove_config
    FileUtils.remove_file config_file if File.file?(config_file)
  end

  def file_content(path)
    IO.binread path
  end

  def json
    JSON.parse response.body
  end

  def products_attrs(count = 10)
    count.times.map { |i| {id: i, name: i.to_s} }
  end
end
