require "active_support/per_thread_registry"

module IoToResponsePayloadRatio
  class AllocatedMemoryRegistry
    extend ActiveSupport::PerThreadRegistry

    METHODS = %i[db_payload_size]

    attr_accessor *METHODS

    METHODS.each do |val|
      class_eval %{ def self.#{val}; instance.#{val}; end }, __FILE__, __LINE__
      class_eval %{ def self.#{val}=(x); instance.#{val}=x; end }, __FILE__, __LINE__
    end
  end
end
