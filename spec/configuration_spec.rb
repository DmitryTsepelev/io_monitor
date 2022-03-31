# frozen_string_literal: true

require "io_to_response_payload_ratio/notifications/instrumentation"
require "io_to_response_payload_ratio/notifications/logs"
require "io_to_response_payload_ratio/notifications/base"

class TestNotification < IoToResponsePayloadRatio::Notifications::Base
end

class TestNotificationCustom
end

RSpec.describe IoToResponsePayloadRatio::Configuration do
  context "when settings warn_threshold" do
    it "sets warn_threshold maximum 1.0" do
      subject.warn_threshold = 10

      expect(subject.warn_threshold).to eq(1.0)
    end

    it "sets warn_threshold minimum 0.0" do
      subject.warn_threshold = -10

      expect(subject.warn_threshold).to eq(0.0)
    end

    it "sets warn_threshold 0.5" do
      subject.warn_threshold = 0.5

      expect(subject.warn_threshold).to eq(0.5)
    end
  end

  context "when settings publish" do
    it "sets publish to logs" do
      subject.publish = :logs

      expect(subject.publish).to eq(:logs)
    end

    it "sets publish to instrumentation" do
      subject.publish = :instrumentation

      expect(subject.publish).to eq(:instrumentation)
    end

    it "returns current_notification Notifications::Logs" do
      subject.publish = :logs

      expect(subject.current_notification).to eq(IoToResponsePayloadRatio::Notifications::Logs)
    end

    it "returns current_notification Notifications::Instrumentation" do
      subject.publish = :instrumentation

      expect(subject.current_notification).to eq(IoToResponsePayloadRatio::Notifications::Instrumentation)
    end

    context "when not correct publish" do
      it "returns current_notification with logs key" do
        subject.publish = :some_fail

        expect(subject.current_notification).to eq(IoToResponsePayloadRatio::Notifications::Logs)
      end
    end
  end

  describe ".add_notification" do
    it "add notifications to available_notification" do
      expect { subject.add_notification(test_notification: TestNotification) }
        .to change(subject, :available_notifications)
    end

    it "don`t add notification" do
      expect { subject.add_notification(test_notification_custom: TestNotificationCustom) }
        .to_not change(subject, :available_notifications)
    end

    it "don`t override exists notification" do
      expect { subject.add_notification(logs: TestNotification) }
        .to_not change { subject.available_notifications[:logs] }
    end

    describe ".current_notification" do
      it "returns added notification" do
        subject.publish = :test_notification
        subject.add_notification(test_notification: TestNotification)

        expect(subject.current_notification).to eq(TestNotification)
      end
    end
  end
end
