# frozen_string_literal: true

RSpec.describe IoMonitor::Aggregator do
  subject(:aggregator) { described_class.new(sources) }

  let(:sources) { %i[active_record] }

  describe ".active?" do
    it "false by default" do
      expect(aggregator.active?).to be false
    end
  end

  describe ".start!" do
    it "makes it active" do
      expect { aggregator.start! }.to change { aggregator.active? }.from(false).to(true)
    end
  end

  describe ".stop!" do
    it "makes it inactive" do
      aggregator.start!

      expect { aggregator.stop! }.to change { aggregator.active? }.from(true).to(false)
    end
  end

  describe ".increment" do
    it "increments the specified source value" do
      aggregator.start!
      aggregator.increment(sources.first, 42)
      expect(aggregator.get(sources.first)).to eq(42)
    end

    context "when inactive" do
      it "doesn't increment the specified source value" do
        aggregator.increment(sources.first, 42)
        expect(aggregator.get(sources.first)).to eq(0)
      end
    end
  end

  describe ".get" do
    it "returns the specified source value" do
      aggregator.start!
      aggregator.increment(sources.first, 42)
      expect(aggregator.get(sources.first)).to eq(42)
    end
  end

  it "is thread-safe" do
    aggregator.start!
    aggregator.increment(sources.first, 42)
    aggregator.stop!

    Thread.new do
      aggregator.start!

      expect(aggregator.get(sources.first)).to eq(0)
      expect(aggregator.active?).to be true
    end.join

    expect(aggregator.get(sources.first)).to eq(42)
    expect(aggregator.active?).to be false
  end
end
