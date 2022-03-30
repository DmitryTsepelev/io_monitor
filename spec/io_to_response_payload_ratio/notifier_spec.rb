# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::Notifier do
  describe "process_action.action_controller handler" do
    let(:event) { "process_action.action_controller" }
    let(:payload) do
      {
        IoToResponsePayloadRatio::NAMESPACE => {
          io_kind => io_payload_size,
          :response => response_payload_size
        }
      }
    end

    let(:io_kind) { :active_record }
    let(:io_payload_size) { 42 }
    let(:response_payload_size) { 42 }

    let(:warn_threshold) { 0.0 }
    let(:publisher) { :logs }

    before do
      IoToResponsePayloadRatio.configure do |config|
        config.warn_threshold = warn_threshold
        config.publish = publisher
      end
    end

    let(:ratio) { response_payload_size.to_f / io_payload_size.to_f }

    context "when warn threshold is reached" do
      let(:warn_threshold) { 0.8 }
      let(:io_payload_size) { response_payload_size * 10 }

      context "when publishing to logs" do
        let(:publisher) { :logs }

        it "logs a warning" do
          allow(Rails.logger).to receive(:warn)

          ActiveSupport::Notifications.instrument(event, payload)

          msg = /#{io_kind.to_s.camelize}.*ratio is #{ratio}.*while threshold is.*/
          expect(Rails.logger).to have_received(:warn).with(msg)
        end
      end

      context "when publishing to notifications" do
        let(:publisher) { :notifications }
        let(:warn_event) { "warn_threshold_reached.#{IoToResponsePayloadRatio::NAMESPACE}" }

        it "instruments warn_threshold_reached event" do
          allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original

          ActiveSupport::Notifications.instrument(event, payload)

          expect(ActiveSupport::Notifications).to have_received(:instrument)
            .with(warn_event, source: io_kind, ratio: ratio)
        end
      end
    end

    context "when event does not contain relevant data" do
      let(:payload) { {} }

      it "does nothing" do
        # if it hasn't even touched warn_threshold then it definitely did nothing
        expect(IoToResponsePayloadRatio.config).not_to receive(:warn_threshold)
      end
    end
  end
end
