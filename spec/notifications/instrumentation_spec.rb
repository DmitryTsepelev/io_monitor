# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::Notifications::Instrumentation do
  let(:content) do
    { payload: { controller: 'FakeController' }, ratio: 0.5 }
  end

  it 'calls ActiveSupport::Notifications' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with(described_class::INSTRUMENT_NAME, content[:payload])

    described_class.new(content).call
  end
end
