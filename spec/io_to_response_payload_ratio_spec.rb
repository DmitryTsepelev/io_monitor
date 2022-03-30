# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio do
  subject { described_class }

  it "has a version number" do
    expect(subject::VERSION).not_to be nil
  end

  describe ".configure" do
    it "yields config" do
      expect(subject).to receive(:configure).and_yield(subject.config)

      subject.configure { |config| }
    end
  end

  def without_memoization(object, property)
    ivar = "@#{property}".to_sym
    old_value = object.instance_variable_get(ivar)
    object.remove_instance_variable(ivar)

    yield

    object.instance_variable_set(ivar, old_value)
  end

  describe ".aggregator" do
    it "filters out disabled sources" do
      without_memoization(subject, :aggregator) do
        adapter = IoToResponsePayloadRatio::ADAPTERS.first
        allow(adapter).to receive(:enabled?).and_return(false)

        expect(subject.aggregator.sources).not_to include(adapter.kind)
      end
    end
  end
end
