# frozen_string_literal: true

require_relative "../allocated_memory_registry"

module IoToResponsePayloadRatio
  module Extensions
    module ActiveRecord
      class << ::ActiveRecord::LogSubscriber
        def db_payload_size
          IoToResponsePayloadRatio::Extensions::AllocatedMemoryRegistry.db_payload_size ||= 0
        end

        def append_db_payload_size=(value)
          self.db_payload_size = db_payload_size + value
        end

        def db_payload_size=(value)
          IoToResponsePayloadRatio::Extensions::AllocatedMemoryRegistry.db_payload_size = value
        end

        def reset_db_payload_size
          rt, self.db_payload_size = db_payload_size, 0
          rt
        end
      end

      module Measure
        IGNORE_CALLER_METHODS = ['all_versions'].freeze

        def self.prepended(cls)
          cls.prepend(Relation)
          cls.prepend(Calculations)
        end

        def self.measuring_method(&block)
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          puts 'MEASUREING BLOCK !!!!!!!!!!!!!!!!!!!!!!!!!!!!'

          caller_method = caller_locations(2,1)[0].base_label

          puts "CALLER METHOD"
          puts caller_method.inspect

          if !defined?(::IoToResponsePayloadRatio::MeasurePayloadSize) || IGNORE_CALLER_METHODS.include?(caller_method)
            return block.call
          end

          obj = ::IoToResponsePayloadRatio::MeasurePayloadSize.new(&block)

          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          #puts obj.inspect
          puts obj.allocated_memory_in_kb
          puts "ALLOCATED MEMORY IN KB allocated_memory_in_kb = #{obj.allocated_memory_in_kb}"

          ::ActiveRecord::LogSubscriber.append_db_payload_size = obj.allocated_memory_in_kb

          obj.result
        end
      end

      module Relation
        def records
          Measure.measuring_method { super }

          #   loaded_records = super
          #
          #   ::ActiveRecord::LogSubscriber.append_allocated_memory = ObjectSpace.memsize_of(loaded_records) / 1024
          #
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts '=================================='
          #   puts loaded_records.inspect
          #
          #   loaded_records
        end

        private

        # def exec_queries(&block)
        #   Measure.measuring_method { super }
        # end

        # def skip_query_cache_if_necessary

        # end
      end

      module Calculations
        def calculate(*)
          Measure.measuring_method { super }
        end

        def pluck(*)
          Measure.measuring_method { super }
        end
      end
    end
  end
end

ActiveRecord::Relation.send(:prepend, IoToResponsePayloadRatio::Extensions::ActiveRecord::Measure)
