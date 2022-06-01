# frozen_string_literal: true

module IoMonitor
  # Thread-safe payload size aggregator.
  class Aggregator
    def initialize(sources)
      @sources = sources
    end

    attr_reader :sources

    def active?
      InputPayload.active.present?
    end

    def collect
      start!
      yield
      stop!
    end

    def start!
      InputPayload.active = true
    end

    def stop!
      InputPayload.active = false
    end

    def increment(source, val)
      return unless active?

      InputPayload.state ||= empty_state
      InputPayload.state[source.to_sym] += val
    end

    def get(source)
      InputPayload.state ||= empty_state
      InputPayload.state[source.to_sym]
    end

    private

    def empty_state
      sources.map { |kind| [kind, 0] }.to_h
    end

    class InputPayload < ActiveSupport::CurrentAttributes
      attribute :state, :active
    end
  end
end
