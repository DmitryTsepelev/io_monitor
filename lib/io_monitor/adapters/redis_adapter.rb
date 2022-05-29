# frozen_string_literal: true

require "io_monitor/patches/redis_patch"

module IoMonitor
  class RedisAdapter < BaseAdapter
    def self.kind
      :redis
    end

    def initialize!
      ActiveSupport.on_load(:after_initialize) do
        Redis.prepend(RedisPatch)
      end
    end
  end
end
