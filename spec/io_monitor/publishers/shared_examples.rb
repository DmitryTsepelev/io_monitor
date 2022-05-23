# frozen_string_literal: true

RSpec.shared_examples "publisher" do |parameter|
  describe ".process_action" do
    let(:event) { "process_action.action_controller" }
    let(:full_payload) { {IoMonitor::NAMESPACE => payload} }

    let(:payload) do
      {
        io_kind => io_payload_size,
        :response => response_payload_size
      }
    end

    let(:io_kind) { :active_record }
    let(:io_payload_size) { 42 }
    let(:response_payload_size) { 42 }

    let(:warn_threshold) { 0.0 }

    before do
      IoMonitor.configure do |config|
        config.warn_threshold = warn_threshold
        config.publish = publisher
      end
    end

    let(:ratio) { response_payload_size.to_f / io_payload_size.to_f }

    it "is called on process_action.action_controller event" do
      expect(publisher).to receive(:process_action).with(payload)

      ActiveSupport::Notifications.instrument(event, full_payload)
    end

    context "when event is irrelevant" do
      let(:full_payload) { {} }

      it "does nothing" do
        expect(publisher).not_to receive(:process_action)

        ActiveSupport::Notifications.instrument(event, full_payload)
      end
    end

    context "when warn threshold is reached" do
      let(:warn_threshold) { 0.8 }
      let(:io_payload_size) { response_payload_size * 10 }

      it "calls .publish method with source and ratio" do
        expect(publisher).to receive(:publish).with(io_kind, ratio)

        publisher.process_action(payload)
      end
    end
  end
end
