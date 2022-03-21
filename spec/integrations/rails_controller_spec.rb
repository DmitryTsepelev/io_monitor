require_relative "./controller_helper"

module FakeControllerBehaviour
  def index
    render json: fake_response
  end

  def fake_response
    {products: [{id: 1, name: "1"}, {id: 2, name: "2"}]}
  end
end

class WithMetricsController < ActionController::Base
  include IoToResponsePayloadRatio::Controller
  include FakeControllerBehaviour
end

class WithoutMetricsController < ActionController::Base
  include FakeControllerBehaviour
end

RSpec.describe "Rails controller integration", type: :controller do
  let(:log) { StringIO.new }

  before do
    ActionController::Base.logger = Logger.new log
  end

  describe WithMetricsController do
    before do
      IoToResponsePayloadRatio.publish = publish_type
      routes.draw { get "index" => "with_metrics#index" }
      get :index
    end

    context "when logs publish type" do
      let(:publish_type) { :logs }

      it "has success status" do
        expect(response).to have_http_status :ok
      end

      it "returns products list" do
        expect(response.body).to eq(controller.fake_response.to_json)
      end

      it "displays body size" do
        expect(log.string).to include "Body: #{"%.2f" % (controller.fake_response.to_json.bytesize / 1000.0)}kB"
      end
    end

    context "when notifications publish type" do
      let(:publish_type) { :notifications }

      it "doesn't display body size" do
        expect(log.string).not_to include "| Body:"
      end
    end
  end

  describe WithoutMetricsController do
    before do
      routes.draw { get "index" => "without_metrics#index" }

      get :index
    end

    it "has success status" do
      expect(response).to have_http_status :ok
    end

    it "returns products list" do
      expect(response.body).to eq(controller.fake_response.to_json)
    end

    it "doesn't display body size" do
      expect(log.string).not_to include "Body:"
    end
  end
end
