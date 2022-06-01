# frozen_string_literal: true

RSpec.describe IoMonitor::Configuration do
  subject(:config) { described_class.new }

  describe ".publish" do
    it "resolves publisher by kind" do
      config.publish = :notifications
      expect(config.publishers.first).to be_a(IoMonitor::NotificationsPublisher)
    end

    context "when kind is unknown" do
      it "raises an error" do
        expect { config.publish = :whatever }.to raise_error(ArgumentError)
      end
    end

    it "allows custom publishers" do
      custom = Class.new(IoMonitor::BasePublisher) {}
      config.publish = custom.new
      expect(config.publishers.first).to be_a(custom)
    end

    it "equals to :logs by default" do
      expect(config.publishers.first).to be_a(IoMonitor::LogsPublisher)
    end

    context "when multiple publishers are set" do
      it "assigns all publishers" do
        config.publish = [:notifications, :logs]
        expect(config.publishers.first).to be_a(IoMonitor::NotificationsPublisher)
        expect(config.publishers.last).to be_a(IoMonitor::LogsPublisher)
      end
    end
  end

  describe ".adapters" do
    it "allows a single adapter instead of an array" do
      expect { config.adapters = :active_record }.not_to raise_error
    end

    it "resolves adapters by kind" do
      config.adapters = %i[active_record]
      expect(config.adapters.first).to be_a(IoMonitor::ActiveRecordAdapter)
    end

    context "when kind is unknown" do
      it "raises an error" do
        expect { config.adapters = %i[whatever] }.to raise_error(ArgumentError)
      end
    end

    it "allows custom adapters" do
      custom = Class.new(IoMonitor::BaseAdapter) {}
      config.adapters = [custom.new]
      expect(config.adapters.first).to be_a(custom)
    end

    it "equals to :active_record by default" do
      expect(config.adapters.first).to be_a(IoMonitor::ActiveRecordAdapter)
    end
  end

  describe ".warn_threshold" do
    it "allows only values in 0..1 range" do
      config.warn_threshold = 0.5
      expect(config.warn_threshold).to eq(0.5)

      expect { config.warn_threshold = 42 }.to raise_error(ArgumentError)
    end

    it "equals to zero by default" do
      expect(config.warn_threshold).to eq(0.0)
    end
  end
end
