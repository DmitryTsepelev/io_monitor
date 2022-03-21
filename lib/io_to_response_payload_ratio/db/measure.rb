require "active_support/per_thread_registry"

module IoToResponsePayloadRatio
  module DB
    module Measure
      def self.prepended(cls)
        cls.prepend InstanceMethods
      end

      module InstanceMethods
        private

        def skip_query_cache_if_necessary
          unless defined?(::IoToResponsePayloadRatio::MeasureMemory)
            return super
          end

          obj = ::IoToResponsePayloadRatio::MeasureMemory.new.measure do
            super
          end

          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts 'ALLOCATED TRACE HERE {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{'
          puts obj.inspect
          puts obj.allocated_memory_in_kb
          puts "ALLOCATED MEMORY IN KB allocated_memory_in_kb = #{obj.allocated_memory_in_kb}"

          ::ActiveRecord::LogSubscriber.allocated_memory = obj.allocated_memory_in_kb

          obj.result
        end
      end
    end
  end
end
