# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::MeasurePayloadSize do
  let(:template_string) { 'Test string for calculate size' }

  it 'equals bytesize with string' do
    expect(described_class.new(template_string).payload_size_in_bytes).to eq(Marshal.dump(template_string).size)
  end
end
