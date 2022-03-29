# frozen_string_literal: true

require_relative './controller_helper'

module FakeControllerBehaviour
  def index
    @products = Product.all

    render json: action_response
  end

  def threshold
    @products = Product.all
    @products.to_a

    render json: { products: [] }
  end

  def query_result
    ActiveRecord::Base.connection.exec_query @products.to_sql
  end

  def action_response
    { products: @products }
  end
end

class WithMetricsController < ActionController::Base
  include IoToResponsePayloadRatio::Controller
  include FakeControllerBehaviour
end

class WithoutMetricsController < ActionController::Base
  include FakeControllerBehaviour
end

class WithMetricsApiController < ActionController::API
  include IoToResponsePayloadRatio::Controller
  include FakeControllerBehaviour
end

class WithoutMetricsApiController < ActionController::API
  include FakeControllerBehaviour
end

RSpec.describe 'Rails controller integration', type: :controller do
  shared_examples 'with metrics' do
    let(:log) { StringIO.new }
    let(:warn_threshold) { 0.5 }
    let(:body_bytes) { controller.action_response.to_json.bytesize }
    let(:db_bytes) do
      res = controller.query_result
      res.columns.join.bytesize + res.rows.map(&:join).join.bytesize
    end

    before do
      logger = Logger.new log
      ActionController::Base.logger = logger
      setup_log_subscriber logger

      IoToResponsePayloadRatio.publish = publish_type
      IoToResponsePayloadRatio.warn_threshold = warn_threshold

      controller_route = controller_route_name(controller)
      routes.draw do
        get 'index' => "#{controller_route}#index"
        get 'threshold' => "#{controller_route}#threshold"
      end

      @measurements = nil
      @subscriber = ActiveSupport::Notifications.subscribe('measurements.io_to_response_payload_ratio') do |*, payload|
        @measurements = payload
      end
    end

    after do
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    end

    context 'when I/O to response ratio is acceptable' do
      before { get :index }

      context 'when logs publish type' do
        let(:publish_type) { :logs }

        it 'has success status' do
          expect(response).to have_http_status :ok
        end

        it 'returns products list' do
          expect(response.body).to eq(controller.action_response.to_json)
        end

        it 'displays body size' do
          expect(log.string).to include "Body: #{format('%.3f', (body_bytes / 1000.0))}kB"
        end

        it 'displays input payload size' do
          expect(log.string).to include "Input Payload: #{format('%.3f', (db_bytes / 1000.0))}kB"
        end

        it "doesn't display warn" do
          expect(log.string).not_to include 'threshold'
        end
      end

      context 'when notifications publish type' do
        let(:publish_type) { :notifications }

        it "doesn't display body size" do
          expect(log.string).not_to include 'Body:'
        end

        it "doesn't display input payload size" do
          expect(log.string).not_to include 'Input Payload:'
        end

        it 'sends a notification with measurement values' do
          expect(@measurements.fetch(:input_payload)).to eq db_bytes
          expect(@measurements.fetch(:body_payload)).to eq body_bytes
        end

        it "doesn't display warn" do
          expect(log.string).not_to include 'threshold'
        end
      end
    end

    context 'when response payload much less than I/O payload' do
      before { get :threshold }

      let(:publish_type) { :logs }
      let(:warn_threshold) { 0.7 }
      let(:body_bytes) { { products: [] }.to_json.bytesize }
      let(:ratio) { (body_bytes / db_bytes.to_f).round(2) }

      it 'displays warn message' do
        expect(log.string).to include(
          "I/O to response payload ratio is #{ratio} while threshold is #{warn_threshold}"
        )
      end
    end
  end

  shared_examples 'without metrics' do
    let(:log) { StringIO.new }

    before do
      logger = Logger.new log
      ActionController::Base.logger = logger
      setup_log_subscriber logger

      controller_route = controller_route_name(controller)
      routes.draw { get 'index' => "#{controller_route}#index" }

      get :index
    end

    it 'has success status' do
      expect(response).to have_http_status :ok
    end

    it 'returns products list' do
      expect(response.body).to eq(controller.action_response.to_json)
    end

    it "doesn't display body size" do
      expect(log.string).not_to include 'Body:'
    end

    it "doesn't display input payload size" do
      expect(log.string).not_to include 'Input Payload:'
    end
  end

  before :all do
    Product.create products_attrs
  end

  describe WithMetricsController do
    include_examples 'with metrics'
  end

  describe WithoutMetricsController do
    include_examples 'without metrics'
  end

  describe WithMetricsApiController do
    include_examples 'with metrics'
  end

  describe WithoutMetricsApiController do
    include_examples 'without metrics'
  end
end
