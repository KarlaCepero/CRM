# frozen_string_literal: true

module Mcp
  module Tools
    module Contacts
      class SearchContactsTool < MCP::Tool
        description "Search contacts by name or email"

        input_schema(
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "Search query to match against contact first name, last name, or email"
            }
          },
          required: ["query"]
        )

        def self.call(query:, server_context:)
          start_time = Time.current

          begin
            contacts = Mcp::QueryBuilders::ContactQueryBuilder.search(query: query)

            data = Mcp::Serializers::ContactSerializer.serialize_collection(contacts)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "search_contacts",
              params: { query: query },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              contacts: data,
              total: contacts.size,
              query: query
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "search_contacts", params: { query: query })
            raise
          end
        end
      end
    end
  end
end
