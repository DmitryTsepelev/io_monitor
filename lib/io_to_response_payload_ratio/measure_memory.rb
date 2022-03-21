require 'get_process_mem'

module IoToResponsePayloadRatio
  class MeasureMemory
    attr_accessor :result

    def measure
      self.start_memory_bytes = GetProcessMem.new.bytes
      self.result = yield
      self.end_memory_bytes = GetProcessMem.new.bytes

      self
    end

    def allocated_memory_in_bytes
      end_memory_bytes - start_memory_bytes
    end

    def allocated_memory_in_kb
      (allocated_memory_in_bytes / GetProcessMem::KB_TO_BYTE).to_f
    end

    private

    attr_accessor :end_memory_bytes, :start_memory_bytes
  end
end
