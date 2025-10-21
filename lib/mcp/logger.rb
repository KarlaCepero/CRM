# frozen_string_literal: true

module Mcp
  class Logger
    def self.log_connection(client_info = {})
      Rails.logger.info "[MCP] Client connected: #{client_info.inspect}"
    end

    def self.log_tool_execution(tool_name:, params:, latency_ms:, success:)
      status = success ? "SUCCESS" : "ERROR"
      Rails.logger.info "[MCP] Tool execution [#{status}]: #{tool_name} | Params: #{params.inspect} | Latency: #{latency_ms}ms"
    end

    def self.log_error(error, context = {})
      Rails.logger.error "[MCP] Error: #{error.message}"
      Rails.logger.error "[MCP] Context: #{context.inspect}"
      Rails.logger.error error.backtrace.join("\n")
    end

    def self.log_auth_failure(token_preview)
      Rails.logger.warn "[MCP] Authentication failure - Token: #{token_preview}"
    end
  end
end
