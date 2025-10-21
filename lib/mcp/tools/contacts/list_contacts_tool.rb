# frozen_string_literal: true

module Mcp
  module Tools
    module Contacts
      class ListContactsTool < MCP::Tool
        description "List all contacts with pagination"

        input_schema(
          type: "object",
          properties: {
            limit: {
              type: "integer",
              description: "Maximum number of contacts to return (default: 100, max: 500)",
              default: 100
            },
            offset: {
              type: "integer",
              description: "Number of contacts to skip for pagination",
              default: 0
            }
          }
        )

        def self.call(limit: 100, offset: 0, server_context:)
          start_time = Time.current

          begin
            contacts = Mcp::QueryBuilders::ContactQueryBuilder.list(
              limit: limit,
              offset: offset
            )

            data = Mcp::Serializers::ContactSerializer.serialize_collection(contacts)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "list_contacts",
              params: { limit: limit, offset: offset },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              contacts: data,
              total: contacts.size,
              limit: limit,
              offset: offset
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "list_contacts", params: { limit: limit, offset: offset })
            raise
          end
        end
      end
    end
  end
end
