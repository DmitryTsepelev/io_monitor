# frozen_string_literal: true

module Rails
  def self.logger
  end
end

RSpec.describe IoToResponsePayloadRatio::Notifications::Logs do
  let(:content) do
    {payload: {controller: "FakeController"}, ratio: 0.5}
  end

  it "calls Rails.logger" do
    class_logger = instance_double("Logger")

    class_double("Rails", logger: class_logger).as_stubbed_const

    object = described_class.new(content)
    message = object.send(:build_message)

    expect(class_logger).to receive(:warn).with(message)

    described_class.new(content).call
  end
end
