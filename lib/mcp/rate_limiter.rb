# frozen_string_literal: true

module Mcp
  class RateLimiter
    class RateLimitExceeded < StandardError; end

    MAX_REQUESTS_PER_MINUTE = 60

    def initialize
      @requests = {}
    end

    def check(client_id)
      now = Time.current
      minute_ago = now - 1.minute

      # Clean old requests
      @requests[client_id] ||= []
      @requests[client_id].reject! { |timestamp| timestamp < minute_ago }

      # Check limit
      if @requests[client_id].size >= MAX_REQUESTS_PER_MINUTE
        Rails.logger.warn "[MCP] Rate limit exceeded for client: #{client_id}"
        raise RateLimitExceeded, "Rate limit exceeded: #{MAX_REQUESTS_PER_MINUTE} requests per minute"
      end

      # Record request
      @requests[client_id] << now
      true
    end
  end
end
