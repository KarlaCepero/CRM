# frozen_string_literal: true

module Mcp
  class Authentication
    class AuthenticationError < StandardError; end

    def self.authenticate(token)
      expected_token = ENV["MCP_AUTH_TOKEN"]

      if expected_token.nil? || expected_token.empty?
        Rails.logger.warn "[MCP] MCP_AUTH_TOKEN not set - authentication disabled"
        return true
      end

      if token != expected_token
        Rails.logger.warn "[MCP] Authentication failed - invalid token"
        raise AuthenticationError, "Invalid authentication token"
      end

      true
    end
  end
end
