# frozen_string_literal: true

require "mcp"

module Mcp
  class Server
    attr_reader :server

    def initialize
      @server = MCP::Server.new(
        name: "crm-mcp-server",
        version: "0.1.0",
        tools: [
          # Company tools
          Mcp::Tools::Companies::ListCompaniesTool,
          Mcp::Tools::Companies::GetCompanyTool,
          Mcp::Tools::Companies::SearchCompaniesTool,
          # Contact tools
          Mcp::Tools::Contacts::ListContactsTool,
          Mcp::Tools::Contacts::GetContactTool,
          Mcp::Tools::Contacts::SearchContactsTool,
          # Deal tools
          Mcp::Tools::Deals::ListDealsTool,
          Mcp::Tools::Deals::GetDealTool,
          Mcp::Tools::Deals::SearchDealsTool,
          Mcp::Tools::Deals::FilterDealsByStageTool,
          # Activity tools
          Mcp::Tools::Activities::ListActivitiesTool,
          Mcp::Tools::Activities::GetActivityTool,
          Mcp::Tools::Activities::ListActivitiesForTool,
          # Note tools
          Mcp::Tools::Notes::ListNotesTool,
          Mcp::Tools::Notes::GetNoteTool,
          Mcp::Tools::Notes::ListNotesForTool
        ]
      )
    end

    def start
      transport = MCP::Server::Transports::StdioTransport.new(@server)
      transport.open
    rescue => e
      $stderr.puts "[MCP] Error starting server: #{e.message}"
      $stderr.puts e.backtrace.join("\n")
      raise
    end
  end
end