require_relative "./controller_helper"

module FakeControllerBehaviour
  def index
    @products = Product.all

    render json: {products: @products}
  end

  def query_result
    ActiveRecord::Base.connection.exec_query @products.to_sql
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

  before :all do
    @products_response = {products: [{id: 1, name: "1"}, {id: 2, name: "2"}]}
    Product.create @products_response[:products]
  end

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
      let(:db_payload) do
        res = controller.query_result
        res.columns.join.bytesize + res.rows.map(&:join).join.bytesize
      end

      it "has success status" do
        expect(response).to have_http_status :ok
      end

      it "returns products list" do
        expect(response.body).to eq(@products_response.to_json)
      end

      it "displays body size" do
        expect(log.string).to include "Body: #{"%.2f" % (@products_response.to_json.bytesize / 1000.0)}kB"
      end

      it "displays db payload size" do
        expect(db_payload).not_to eq 0
        expect(log.string).to include "DB Payload: #{"%.2f" % (db_payload / 1000.0)}kB"
      end
    end

    context "when notifications publish type" do
      let(:publish_type) { :notifications }

      it "doesn't display body size" do
        expect(log.string).not_to include "| Body:"
      end

      it "doesn't display db payload size" do
        expect(log.string).not_to include "| DB Payload:"
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
      expect(response.body).to eq(@products_response.to_json)
    end

    it "doesn't display body size" do
      expect(log.string).not_to include "Body:"
    end

    it "doesn't display db payload size" do
      expect(log.string).not_to include "| DB Payload:"
    end
  end
end
