# frozen_string_literal: true

RSpec.describe IoMonitor::Controller, type: :controller do
  controller(ApplicationController) do
    include IoMonitor::Controller

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
    IoMonitor.configure do |config|
      config.publish = publisher
    end
  end

  let(:publisher) { :logs }

  it "adds info to process_action.action_controller payload for each source" do
    event = "process_action.action_controller"

    subscription = ActiveSupport::Notifications.subscribe(event) do |*args|
      payload = args.last[IoMonitor::NAMESPACE]

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
      expect(infos).to include(/ActiveRecord Payload: \d+ Bytes/)
      expect(infos).to include(/Response Payload: \d+ Bytes/)
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

  context "when monitor_io_for is configured" do
    controller(ApplicationController) do
      include IoMonitor::Controller

      monitor_io_for :index

      def index
        render json: Fake.all
      end

      def show
        render json: Fake.first
      end
    end

    it "adds info to ActionController log entry" do
      infos = get_info_logs { get :index }

      expect(infos).to include(/Completed 200 OK/)
      expect(infos).to include(/ActiveRecord Payload: \d+ Bytes/)
      expect(infos).to include(/Response Payload: \d+ Bytes/)
    end

    context "when action is not included to the list of monitored ones" do
      it "doesn't modify ActionController log entry" do
        infos = get_info_logs { get :show, params: {id: 1} }

        expect(infos).to include(/Completed 200 OK/)
        expect(infos).not_to include(/ActiveRecord Payload:/)
        expect(infos).not_to include(/Response Payload:/)
      end
    end
  end
end

RSpec.describe "when response is nil", type: :request do
  it "does not fail" do
    get "/fake"

    expect(response).to be_not_found
  end
end
