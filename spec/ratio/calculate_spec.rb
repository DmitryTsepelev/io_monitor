# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::Ratio::Calculate do
  context 'when response_payload_size is zero' do
    it 'returns ratio 1' do
      expect(described_class.new(response_payload_size: 0, source_payload_size: 0).ratio).to eq(1)
    end

    it 'returns ratio 0' do
      expect(described_class.new(response_payload_size: 0, source_payload_size: 10).ratio).to eq(0)
    end
  end

  context 'when source_payload_size is zero' do
    it 'returns ratio 1' do
      expect(described_class.new(response_payload_size: 10, source_payload_size: 0).ratio).to eq(1)
    end
  end

  it 'returns ratio 1' do
    expect(described_class.new(response_payload_size: 10, source_payload_size: 5).ratio).to eq(1)
  end

  it 'returns ratio 0.1' do
    expect(described_class.new(response_payload_size: 1, source_payload_size: 10).ratio).to eq(0.1)
  end
end
