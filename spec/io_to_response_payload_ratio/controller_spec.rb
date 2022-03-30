# frozen_string_literal: true

RSpec.describe IoToResponsePayloadRatio::Controller, type: :controller do
  controller(ApplicationController) do
    include IoToResponsePayloadRatio::Controller

    def index
      render json: Fake.all
    end
  end

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
    IoToResponsePayloadRatio.configure do |config|
      config.publish = publisher
    end
  end

  let(:publisher) { :logs }

  it "adds info to process_action.action_controller payload for each source" do
    event = "process_action.action_controller"

    subscription = ActiveSupport::Notifications.subscribe(event) do |*args|
      payload = args.last[IoToResponsePayloadRatio::NAMESPACE]

      expect(payload[:active_record]).to eq(Fake.pluck(:id, :name).flatten.join.bytesize)
      expect(payload[:response]).to eq(args.last[:response].body.bytesize)
    end

    get :index

    ActiveSupport::Notifications.unsubscribe(subscription)
  end

  # ActionControllerBasePatch related specs are here as well for convenience:

  def get_info_logs
    [].tap do |infos|
      # `info` is called with a block in ActionController::LogSubscriber
      allow(Rails.logger).to receive(:info) { |&block| infos << block.call }

      yield
    end
  end

  context "when publisher is set to logs" do
    let(:publisher) { :logs }

    it "adds info to ActionController log entry" do
      infos = get_info_logs { get :index }

      expect(infos).to include(/Completed 200 OK/)
      expect(infos).to include(/ActiveRecord Payload: \d+\.\d+ B/)
      expect(infos).to include(/Response Payload: \d+\.\d+ B/)
    end
  end

  context "when publisher is not set to logs" do
    let(:publisher) { :notifications }

    it "doesn't modify ActionController log entry" do
      infos = get_info_logs { get :index }

      expect(infos).to include(/Completed 200 OK/)
      expect(infos).not_to include(/ActiveRecord Payload:/)
      expect(infos).not_to include(/Response Payload:/)
    end
  end

  context "when concern is not included" do
    controller(ApplicationController) do
      def index
        render json: Fake.all
      end
    end

    it "doesn't modify ActionController log entry" do
      infos = get_info_logs { get :index }

      expect(infos).to include(/Completed 200 OK/)
      expect(infos).not_to include(/ActiveRecord Payload:/)
      expect(infos).not_to include(/Response Payload:/)
    end
  end
end
