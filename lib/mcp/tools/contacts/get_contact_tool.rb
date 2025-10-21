# frozen_string_literal: true

module Mcp
  module Tools
    module Contacts
      class GetContactTool < MCP::Tool
        description "Get a specific contact by ID with full details including company and deals"

        input_schema(
          type: "object",
          properties: {
            id: {
              type: "integer",
              description: "The ID of the contact to retrieve"
            }
          },
          required: ["id"]
        )

        def self.call(id:, server_context:)
          start_time = Time.current

          begin
            contact = Mcp::QueryBuilders::ContactQueryBuilder.find(id: id)

            unless contact
              return MCP::Tool::Response.new([
                { type: "text", text: JSON.pretty_generate({ error: "Contact not found", id: id }) }
              ])
            end

            data = Mcp::Serializers::ContactSerializer.serialize(contact)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "get_contact",
              params: { id: id },
              latency_ms: latency_ms,
              success: true
            )

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(data) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "get_contact", params: { id: id })
            raise
          end
        end
      end
    end
  end
end
