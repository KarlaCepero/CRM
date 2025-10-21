# frozen_string_literal: true

namespace :mcp do
  desc "Start MCP server"
  task server: :environment do
    require_relative "../mcp/server"

 
    auth_status = ENV["MCP_AUTH_TOKEN"] ? "Enabled" : "DISABLED (set MCP_AUTH_TOKEN)"


    server = Mcp::Server.new
    server.start
  end
end
