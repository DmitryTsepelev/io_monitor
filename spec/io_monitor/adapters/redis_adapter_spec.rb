# frozen_string_literal: true

require_relative "../../../lib/io_monitor/adapters/redis_adapter"

RSpec.describe IoMonitor::RedisAdapter do
  let(:aggregator) { IoMonitor.aggregator }

  let(:key) { "key" }
  let(:value) { "Hello, World!" }

  let(:redis_client) { instance_double(Redis::Client) }
  let(:redis) { Redis.new }

  before do
    allow(redis_client).to receive(:call_v).and_return(value)
    allow(Redis::Client).to receive(:new).and_return(redis_client)
  end

  around do |example|
    aggregator.collect { example.run }
  end

  context "when aggregator is inactive" do
    before do
      aggregator.stop!
    end

    it "does nothing" do
      expect(aggregator).not_to receive(:increment)
      redis.get(key)
    end
  end

  it "increments aggregator by request's body bytesize" do
    allow(aggregator).to receive(:increment)
    redis.get(key)
    expect(aggregator).to have_received(:increment).with(described_class.kind, value.bytesize)
  end

  context "when response is QUEUED" do
    before do
      allow(redis_client).to receive(:call_v).and_return("QUEUED")
    end

    it "does nothing" do
      expect(aggregator).not_to receive(:increment)
      redis.get(key)
    end
  end

  context "when response is error" do
    before do
      allow(redis_client).to receive(:call_v).and_return(Redis::CommandError.new("ERROR"))
    end

    it "does nothing" do
      expect(aggregator).not_to receive(:increment)
      redis.get(key)
    end
  end
end
