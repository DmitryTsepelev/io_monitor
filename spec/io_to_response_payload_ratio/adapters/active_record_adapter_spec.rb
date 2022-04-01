# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::ActiveRecordAdapter do
  let(:aggregator) { IoToResponsePayloadRatio.aggregator }

  with_model :Fake, scope: :all do
    table do |t|
      t.string :name
    end

    model {}
  end

  before(:all) do
    (1..10).each { |i| Fake.create!(name: "Fake #{i}") }
  end

  after(:all) do
    Fake.delete_all
  end

  before do
    aggregator.reset!
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

      Fake.all.to_a
    end
  end

  it "increments aggregator by query result's bytesize" do
    allow(aggregator).to receive(:increment)

    bytesize = Fake.pluck(:id, :name).flatten.join.bytesize

    expect(aggregator).to have_received(:increment).with(described_class.kind, bytesize)
  end
end
