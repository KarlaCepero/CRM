# frozen_string_literal: true

module Mcp
  module Tools
    module Deals
      class SearchDealsTool < MCP::Tool
        description "Search deals by title"

        input_schema(
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "Search query to match against deal title"
            }
          },
          required: ["query"]
        )

        def self.call(query:, server_context:)
          start_time = Time.current

          begin
            deals = Mcp::QueryBuilders::DealQueryBuilder.search(query: query)

            data = Mcp::Serializers::DealSerializer.serialize_collection(deals)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "search_deals",
              params: { query: query },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              deals: data,
              total: deals.size,
              query: query
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "search_deals", params: { query: query })
            raise
          end
        end
      end
    end
  end
end
