# frozen_string_literal: true

require "io_to_response_payload_ratio"
require "io_to_response_payload_ratio/notifications/logs"
require "io_to_response_payload_ratio/notifications/instrumentation"

module Rails
  def self.logger
    Logger.new(StringIO.new)
  end
end

RSpec.describe IoToResponsePayloadRatio::Notifications::Resolver do
  context "when ratio less than configuration.warn_threshold" do
    let(:content) do
      {payload: {controller: "FakeController"}, ratio: 0.5}
    end

    let(:notification_log) do
      IoToResponsePayloadRatio::Notifications::Logs
    end

    let(:notification_instrumentation) do
      IoToResponsePayloadRatio::Notifications::Instrumentation
    end

    it "calls Notifications::Logs with ratio_message" do
      IoToResponsePayloadRatio.configure do |config|
        config.publish = :logs
      end

      object = described_class.new(content)
      message = object.send(:build_message)

      expect(notification_log).to(
        receive(:new)
          .with(hash_including(payload: hash_including(ratio_message: message)))
          .and_return(notification_log.new(content))
      )

      object.call
    end

    it "calls Notifications::Instrumentation with ratio_message" do
      IoToResponsePayloadRatio.configure do |config|
        config.publish = :instrumentation
      end

      object = described_class.new(content)
      message = object.send(:build_message)

      expect(notification_instrumentation).to(
        receive(:new)
          .with(hash_including(payload: hash_including(ratio_message: message)))
          .and_return(notification_instrumentation.new(content))
      )

      object.call
    end
  end

  context "when ratio more or equal than configuration.warn_threshold" do
    let(:content) do
      {payload: {controller: "FakeController"}, ratio: 1.0}
    end

    it "not calls Notifications::Logs" do
      IoToResponsePayloadRatio.configure do |config|
        config.publish = :logs
      end

      object = described_class.new(content)

      expect(object.call).to eq(nil)
    end
  end
end
