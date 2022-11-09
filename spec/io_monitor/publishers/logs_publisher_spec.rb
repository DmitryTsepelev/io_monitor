# frozen_string_literal: true

require_relative "shared_examples"

RSpec.describe IoMonitor::LogsPublisher do
  subject(:publisher) { described_class.new }

  it_behaves_like "publisher"

  describe ".publish" do
    it "logs a warning" do
      msg = /ActiveRecord I\/O to response payload ratio is 0.5/
      expect(Rails.logger).to receive(:warn).with(msg)

      publisher.publish(:active_record, 0.5)
    end
  end
end
