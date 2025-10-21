# frozen_string_literal: true

module Mcp
  module Tools
    module Deals
      class GetDealTool < MCP::Tool
        description "Get a specific deal by ID with full details including contact and company"

        input_schema(
          type: "object",
          properties: {
            id: {
              type: "integer",
              description: "The ID of the deal to retrieve"
            }
          },
          required: ["id"]
        )

        def self.call(id:, server_context:)
          start_time = Time.current

          begin
            deal = Mcp::QueryBuilders::DealQueryBuilder.find(id: id)

            unless deal
              return MCP::Tool::Response.new([
                { type: "text", text: JSON.pretty_generate({ error: "Deal not found", id: id }) }
              ])
            end

            data = Mcp::Serializers::DealSerializer.serialize(deal)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "get_deal",
              params: { id: id },
              latency_ms: latency_ms,
              success: true
            )

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(data) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "get_deal", params: { id: id })
            raise
          end
        end
      end
    end
  end
end
