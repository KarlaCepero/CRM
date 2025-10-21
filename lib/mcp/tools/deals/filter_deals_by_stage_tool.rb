# frozen_string_literal: true

module Mcp
  module Tools
    module Deals
      class FilterDealsByStageTool < MCP::Tool
        description "Filter deals by stage (lead, qualification, proposal, negotiation, closed_won, closed_lost)"

        input_schema(
          type: "object",
          properties: {
            stage: {
              type: "string",
              description: "The stage to filter by",
              enum: ["lead", "qualification", "proposal", "negotiation", "closed_won", "closed_lost"]
            }
          },
          required: ["stage"]
        )

        def self.call(stage:, server_context:)
          start_time = Time.current

          begin
            deals = Mcp::QueryBuilders::DealQueryBuilder.filter_by_stage(stage: stage)

            data = Mcp::Serializers::DealSerializer.serialize_collection(deals)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "filter_deals_by_stage",
              params: { stage: stage },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              deals: data,
              total: deals.size,
              stage: stage
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue ArgumentError => e
            Mcp::Logger.log_error(e, tool: "filter_deals_by_stage", params: { stage: stage })
            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate({ error: e.message, stage: stage }) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "filter_deals_by_stage", params: { stage: stage })
            raise
          end
        end
      end
    end
  end
end
