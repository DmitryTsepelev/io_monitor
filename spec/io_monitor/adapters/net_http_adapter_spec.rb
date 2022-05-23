# frozen_string_literal: true

RSpec.describe IoMonitor::NetHttpAdapter do
  let(:aggregator) { IoMonitor.aggregator }
  let(:body) { "Hello, World!" }
  let(:url) { "www.example.com" }

  before do
    stub_request(:get, url).to_return body: body
  end

  before do
    aggregator.start!
  end

  after do
    aggregator.stop!
  end

  context "when aggregator is inactive" do
    before do
      aggregator.stop!
    end

    it "does nothing" do
      expect(aggregator).not_to receive(:increment)

      Net::HTTP.get url, "/"
    end
  end

  it "increments aggregator by request's body bytesize" do
    allow(aggregator).to receive(:increment)

    Net::HTTP.get url, "/"

    expect(aggregator).to have_received(:increment).with(described_class.kind, body.bytesize)
  end
end
