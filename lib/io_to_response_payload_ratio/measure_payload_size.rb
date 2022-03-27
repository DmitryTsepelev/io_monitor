# frozen_string_literal: true

require 'objspace'

module IoToResponsePayloadRatio
  class MeasurePayloadSize
    attr_accessor :result, :payload_bytes

    def initialize(data = nil)
      self.result =
        if block_given?
          yield
        else
          data
        end

      self.payload_bytes = Marshal.dump(result).size
      #self.payload_bytes = MeasureObjectSpace.new(result).size
    end

    def allocated_memory_in_bytes
      payload_bytes
    end

    def allocated_memory_in_kb
      (payload_bytes / 1024).to_f
    end
  end

  class MeasureObjectSpace
    attr_reader :size

    SIMPLE_CLASSES = [String, Symbol, Integer, Float, Numeric, Date, Time, TrueClass, FalseClass].freeze
    BASE_CLASSES = [Class, Object].freeze

    def initialize(obj)
      @size = 0

      measuring_mem_size!(obj)
    end

    private

    attr_writer :size

    def measuring_mem_size!(object)
      return if object.nil?

      if SIMPLE_CLASSES.include?(object.class)
        self.size += ObjectSpace.memsize_of(object)

        return
      end

      if object.instance_of?(Array)
        object.each do |obj|

          measuring_mem_size!(obj)
        end

        return
      end

      ObjectSpace.reachable_objects_from(object).each do |related_object|
        if related_object.is_a?(ObjectSpace::InternalObjectWrapper) || BASE_CLASSES.include?(related_object.class)
          next
        end

        self.size += ObjectSpace.memsize_of(related_object)

        measuring_mem_size!(related_object)
      end
    end
  end
end
