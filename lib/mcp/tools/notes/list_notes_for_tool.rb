# frozen_string_literal: true

module Mcp
  module Tools
    module Notes
      class ListNotesForTool < MCP::Tool
        description "List notes for a specific company, contact, or deal"

        input_schema(
          type: "object",
          properties: {
            type: {
              type: "string",
              description: "The type of entity (Company, Contact, or Deal)",
              enum: ["Company", "Contact", "Deal"]
            },
            id: {
              type: "integer",
              description: "The ID of the entity"
            }
          },
          required: ["type", "id"]
        )

        def self.call(type:, id:, server_context:)
          start_time = Time.current

          begin
            notes = Mcp::QueryBuilders::NoteQueryBuilder.list_for_notable(
              type: type,
              id: id
            )

            data = Mcp::Serializers::NoteSerializer.serialize_collection(notes)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "list_notes_for",
              params: { type: type, id: id },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              notes: data,
              total: notes.size,
              type: type,
              id: id
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "list_notes_for", params: { type: type, id: id })
            raise
          end
        end
      end
    end
  end
end
