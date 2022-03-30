# frozen_string_literal: true

require 'io_to_response_payload_ratio'
require 'io_to_response_payload_ratio/extensions/active_record/extension'

module ActiveRecord
  class Base
    establish_connection(adapter: 'sqlite3', database: ':memory:')
    connection.create_table(:transactions) { |t| t.string :token; t.string :name; t.integer :price }
    self.logger = Logger.new(::LOGGER = StringIO.new)
  end
end

class Transaction < ActiveRecord::Base; end

RSpec.describe IoToResponsePayloadRatio do
  describe ActiveRecord::LogSubscriber do
    context 'when calculating db_payload_size' do
      before(:all) do
        @data_name_with_token = []
        @price_sum = 0
        @transactions_data =
          (0..30).map do |i|
            @data_name_with_token << ["transaction_name_#{i}", "transaction_uniq_test_token_#{i}"]
            @price_sum += i

            { name: "transaction_name_#{i}", token: "transaction_uniq_test_token_#{i}", price: i }
          end

        Transaction.create(@transactions_data)

        @transaction_objects = Transaction.select(:name, :token).to_a

        ActiveRecord::LogSubscriber.reset_db_payload_size
      end

      after { ActiveRecord::LogSubscriber.reset_db_payload_size }

      context 'when compares loaded data by methods' do
        it 'should calculate payload bytes for select, more then pluck' do
          Transaction.select(:name, :token).to_a

          expect(ActiveRecord::LogSubscriber.db_payload_size)
            .to be > IoToResponsePayloadRatio::MeasurePayloadSize.new(@data_name_with_token).payload_size_in_kb
        end
      end

      it 'calls AR pluck' do
        expect { Transaction.pluck(:name, :token) }
          .to change{ ActiveRecord::LogSubscriber.db_payload_size }
            .by(IoToResponsePayloadRatio::MeasurePayloadSize.new(@data_name_with_token).payload_size_in_kb)
      end

      it 'calls AR select' do
        expect { Transaction.select(:name, :token).to_a }
          .to change{ ActiveRecord::LogSubscriber.db_payload_size }
            .by(IoToResponsePayloadRatio::MeasurePayloadSize.new(@transaction_objects).payload_size_in_kb)
      end

      it 'calls AR sum' do
        expect { Transaction.sum(:price) }
          .to change{ ActiveRecord::LogSubscriber.db_payload_size }
            .by(IoToResponsePayloadRatio::MeasurePayloadSize.new(@price_sum).payload_size_in_kb)
      end
    end
  end

  it "has a version number" do
    expect(IoToResponsePayloadRatio::VERSION).not_to be nil
  end
end
