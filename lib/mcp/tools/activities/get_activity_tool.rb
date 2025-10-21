# frozen_string_literal: true

module Mcp
  module Tools
    module Activities
      class GetActivityTool < MCP::Tool
        description "Get a specific activity by ID with full details"

        input_schema(
          type: "object",
          properties: {
            id: {
              type: "integer",
              description: "The ID of the activity to retrieve"
            }
          },
          required: ["id"]
        )

        def self.call(id:, server_context:)
          start_time = Time.current

          begin
            activity = Mcp::QueryBuilders::ActivityQueryBuilder.find(id: id)

            unless activity
              return MCP::Tool::Response.new([
                { type: "text", text: JSON.pretty_generate({ error: "Activity not found", id: id }) }
              ])
            end

            data = Mcp::Serializers::ActivitySerializer.serialize(activity)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "get_activity",
              params: { id: id },
              latency_ms: latency_ms,
              success: true
            )

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(data) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "get_activity", params: { id: id })
            raise
          end
        end
      end
    end
  end
end
