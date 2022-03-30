# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::Configuration do
  subject(:config) { described_class.new }

  describe ".publish" do
    it "allows only allowed publishers" do
      config.publish = :notifications
      expect(config.publish).to eq(:notifications)

      expect { config.publish = :whatever }.to raise_error(ArgumentError)
    end

    it "equals to :logs by default" do
      expect(config.publish).to eq(:logs)
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
