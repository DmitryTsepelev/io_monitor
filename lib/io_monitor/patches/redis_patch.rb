# frozen_string_literal: true

module IoMonitor
  module RedisPatch
    def send_command(command, &block)
      super(command, &block).tap do |reply|
        # we need to check QUEUED because of https://github.com/redis/redis-rb/blob/cbdb53e8c2f0be53c91404cb7ff566a36fc8ebf5/lib/redis/client.rb#L164
        if reply != "QUEUED" && !reply.is_a?(Redis::CommandError) && IoMonitor.aggregator.active?
          IoMonitor.aggregator.increment(RedisAdapter.kind, reply.bytesize)
        end
      end
    end
  end
end
