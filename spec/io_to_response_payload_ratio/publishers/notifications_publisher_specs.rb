# frozen_string_literal: true

require_relative "shared_examples"

RSpec.describe IoToResponsePayloadRatio::NotificationsPublisher do
  subject(:publisher) { described_class.new }

  it_behaves_like "publisher"

  describe ".publish" do
    it "instruments warn_threshold_reached event" do
      warn_event = "warn_threshold_reached.#{IoToResponsePayloadRatio::NAMESPACE}"
      expect(ActiveSupport::Notifications).to receive(:instrument)
        .with(warn_event, source: :active_record, ratio: 0.5)

      publisher.publish(:active_record, 0.5)
    end
  end
end
