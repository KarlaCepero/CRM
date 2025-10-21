# frozen_string_literal: true

module Mcp
  module Tools
    module Activities
      class ListActivitiesTool < MCP::Tool
        description "List all activities with pagination"

        input_schema(
          type: "object",
          properties: {
            limit: {
              type: "integer",
              description: "Maximum number of activities to return (default: 100, max: 500)",
              default: 100
            },
            offset: {
              type: "integer",
              description: "Number of activities to skip for pagination",
              default: 0
            }
          }
        )

        def self.call(limit: 100, offset: 0, server_context:)
          start_time = Time.current

          begin
            activities = Mcp::QueryBuilders::ActivityQueryBuilder.list(
              limit: limit,
              offset: offset
            )

            data = Mcp::Serializers::ActivitySerializer.serialize_collection(activities)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "list_activities",
              params: { limit: limit, offset: offset },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              activities: data,
              total: activities.size,
              limit: limit,
              offset: offset
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "list_activities", params: { limit: limit, offset: offset })
            raise
          end
        end
      end
    end
  end
end
