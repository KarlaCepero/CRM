# frozen_string_literal: true

module Mcp
  module Tools
    module Notes
      class GetNoteTool < MCP::Tool
        description "Get a specific note by ID with full details"

        input_schema(
          type: "object",
          properties: {
            id: {
              type: "integer",
              description: "The ID of the note to retrieve"
            }
          },
          required: ["id"]
        )

        def self.call(id:, server_context:)
          start_time = Time.current

          begin
            note = Mcp::QueryBuilders::NoteQueryBuilder.find(id: id)

            unless note
              return MCP::Tool::Response.new([
                { type: "text", text: JSON.pretty_generate({ error: "Note not found", id: id }) }
              ])
            end

            data = Mcp::Serializers::NoteSerializer.serialize(note)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "get_note",
              params: { id: id },
              latency_ms: latency_ms,
              success: true
            )

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(data) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "get_note", params: { id: id })
            raise
          end
        end
      end
    end
  end
end
