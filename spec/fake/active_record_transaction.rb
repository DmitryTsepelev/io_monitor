module ActiveRecord
  class Base
    establish_connection(adapter: 'sqlite3', database: ':memory:')
    connection.create_table(:transactions) { |t| t.string :token; t.string :name; t.integer :price }
    self.logger = Logger.new(::LOGGER = StringIO.new)
  end
end

class Transaction < ActiveRecord::Base; end
