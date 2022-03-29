# frozen_string_literal: true

require 'generators/io_to_response_payload_ratio/install_generator'

RSpec.describe IoToResponsePayloadRatio::Generators::InstallGenerator do
  before :all do
    remove_config
    described_class.start
  end

  after :all do
    remove_config
  end

  let(:content) { file_content(config_file) }

  it 'generates config file' do
    expect(File.file?(config_file)).to be true
  end

  it 'generates valid file content' do
    expect(content).to include IoToResponsePayloadRatio.name
    expect(content).to include "warn_threshold = #{IoToResponsePayloadRatio.warn_threshold}"
    expect(content).to include "publish = #{IoToResponsePayloadRatio.publish.inspect}"
  end
end
