require_relative "./controller_helper"

module FakeControllerBehaviour
  def index
    @products = Product.all

    render json: {products: @products}
  end

  def threshold
    @products = Product.all
    @products.to_a

    render json: {products: []}
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
  let(:db_bytes) do
    res = controller.query_result
    res.columns.join.bytesize + res.rows.map(&:join).join.bytesize
  end

  before :all do
    attrs = products_attrs
    Product.create attrs

    @products_response = {products: attrs}.to_json
    @body_bytes = @products_response.bytesize
  end

  before do
    ActionController::Base.logger = Logger.new log
  end

  describe WithMetricsController do
    let(:warn_threshold) { 0.5 }

    before do
      IoToResponsePayloadRatio.publish = publish_type
      IoToResponsePayloadRatio.warn_threshold = warn_threshold

      routes.draw do
        get "index" => "with_metrics#index"
        get "threshold" => "with_metrics#threshold"
      end

      @measurements = nil
      @subscriber = ActiveSupport::Notifications.subscribe("measurements.io_to_response_payload_ratio") do |*, payload|
        @measurements = payload
      end
    end

    after do
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    end

    context "without threshold warning" do
      before { get :index }

      context "when logs publish type" do
        let(:publish_type) { :logs }

        it "has success status" do
          expect(response).to have_http_status :ok
        end

        it "returns products list" do
          expect(response.body).to eq(@products_response)
        end

        it "displays body size" do
          expect(log.string).to include "Body: #{"%.2f" % (@body_bytes / 1000.0)}kB"
        end

        it "displays input payload size" do
          expect(log.string).to include "Input Payload: #{"%.2f" % (db_bytes / 1000.0)}kB"
        end

        it "doesn't display warn" do
          expect(log.string).not_to include "threshold"
        end
      end

      context "when notifications publish type" do
        let(:publish_type) { :notifications }

        it "doesn't display body size" do
          expect(log.string).not_to include "| Body:"
        end

        it "doesn't display input payload size" do
          expect(log.string).not_to include "| Input Payload:"
        end

        it "sends a notification with measurement values" do
          expect(@measurements.fetch(:input_payload)).to eq db_bytes
          expect(@measurements.fetch(:body_payload)).to eq @body_bytes
        end

        it "doesn't display warn" do
          expect(log.string).not_to include "threshold"
        end
      end
    end

    context "when response payload much less than I/O payload" do
      before { get :threshold }

      let(:publish_type) { :logs }
      let(:warn_threshold) { 0.7 }
      let(:body_bytes) { {products: []}.to_json.bytesize }
      let(:ratio) { (body_bytes / db_bytes.to_f).round(2) }

      it "displays warn message" do
        expect(log.string).to include(
          "I/O to response payload ratio is #{ratio} while threshold is #{warn_threshold}"
        )
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
      expect(response.body).to eq(@products_response)
    end

    it "doesn't display body size" do
      expect(log.string).not_to include "Body:"
    end

    it "doesn't display input payload size" do
      expect(log.string).not_to include "| Input Payload:"
    end
  end
end
