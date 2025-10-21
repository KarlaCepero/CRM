# frozen_string_literal: true

module Mcp
  module Tools
    module Notes
      class ListNotesTool < MCP::Tool
        description "List all notes with pagination"

        input_schema(
          type: "object",
          properties: {
            limit: {
              type: "integer",
              description: "Maximum number of notes to return (default: 100, max: 500)",
              default: 100
            },
            offset: {
              type: "integer",
              description: "Number of notes to skip for pagination",
              default: 0
            }
          }
        )

        def self.call(limit: 100, offset: 0, server_context:)
          start_time = Time.current

          begin
            notes = Mcp::QueryBuilders::NoteQueryBuilder.list(
              limit: limit,
              offset: offset
            )

            data = Mcp::Serializers::NoteSerializer.serialize_collection(notes)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "list_notes",
              params: { limit: limit, offset: offset },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              notes: data,
              total: notes.size,
              limit: limit,
              offset: offset
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "list_notes", params: { limit: limit, offset: offset })
            raise
          end
        end
      end
    end
  end
end
