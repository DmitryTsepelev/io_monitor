# frozen_string_literal: true

require_relative "shared_examples"
require "prometheus/client"

RSpec.describe IoMonitor::PrometheusPublisher do
  subject(:publisher) { described_class.new(registry: registry) }

  let(:registry) { ::Prometheus::Client.registry }
  let(:metric) { ::Prometheus::Client::Histogram.new(:test, docstring: "...") }

  before { expect(registry).to receive(:histogram).and_return(metric) }

  it_behaves_like "publisher"

  describe ".publish" do
    it "changes prometheus metrics" do
      expect(metric).to receive(:observe)
        .with(0.5, labels: {adapter: :active_record})

      publisher.publish(:active_record, 0.5)
    end
  end
end
