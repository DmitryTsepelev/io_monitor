# frozen_string_literal: true

require "concurrent"

module IoToResponsePayloadRatio
  # Thread-safe payload size aggregator.
  class Aggregator
    def initialize(sources)
      @sources = sources
      @active = Concurrent::ThreadLocalVar.new(false)
      @state = Concurrent::ThreadLocalVar.new(empty_state)
    end

    attr_reader :sources

    def active?
      active.value
    end

    def start!
      active.value = true
    end

    def stop!
      active.value = false
    end

    def reset!
      state.value = empty_state
    end

    def increment(source, val)
      return unless active?

      state.value[source.to_sym] += val
    end

    def get(source)
      state.value[source.to_sym]
    end

    private

    attr_reader :active, :state

    def empty_state
      sources.map { |kind| [kind, 0] }.to_h
    end
  end
end
