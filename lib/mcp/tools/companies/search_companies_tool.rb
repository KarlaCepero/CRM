# frozen_string_literal: true

module Mcp
  module Tools
    module Companies
      class SearchCompaniesTool < MCP::Tool
        description "Search companies by name or email"

        input_schema(
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "Search query to match against company name or email"
            }
          },
          required: ["query"]
        )

        def self.call(query:, server_context:)
          start_time = Time.current

          begin
            companies = Mcp::QueryBuilders::CompanyQueryBuilder.search(query: query)

            data = Mcp::Serializers::CompanySerializer.serialize_collection(companies)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "search_companies",
              params: { query: query },
              latency_ms: latency_ms,
              success: true
            )

            result = {
              companies: data,
              total: companies.size,
              query: query
            }

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(result) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "search_companies", params: { query: query })
            raise
          end
        end
      end
    end
  end
end
