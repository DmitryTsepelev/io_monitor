# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio do
  it 'has a version number' do
    expect(IoToResponsePayloadRatio::VERSION).not_to be_nil
  end

  describe '::configure' do
    it 'allows to provide configurations' do
      described_class.configure do |c|
        expect(c).to eq(described_class)
      end
    end
  end

  describe '::warn_threshold=' do
    context 'with valid argument' do
      it 'sets to the new value' do
        expect { described_class.warn_threshold = 0.5 }.not_to raise_error
      end
    end

    context 'with invalid argument' do
      it 'raises ArgumentError' do
        expect { described_class.warn_threshold = -1 }.to raise_error(ArgumentError)
      end
    end
  end

  describe '::publish=' do
    context 'with valid argument' do
      it 'sets to the new value' do
        expect { described_class.publish = :logs }.not_to raise_error
      end
    end

    context 'with invalid argument' do
      it 'raises ArgumentError' do
        expect { described_class.publish = :foo }.to raise_error(ArgumentError)
      end
    end
  end
end
