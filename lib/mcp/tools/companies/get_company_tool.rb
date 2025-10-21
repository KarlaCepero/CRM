# frozen_string_literal: true

module Mcp
  module Tools
    module Companies
      class GetCompanyTool < MCP::Tool
        description "Get a specific company by ID with full details including contacts and deals"

        input_schema(
          type: "object",
          properties: {
            id: {
              type: "integer",
              description: "The ID of the company to retrieve"
            }
          },
          required: ["id"]
        )

        def self.call(id:, server_context:)
          start_time = Time.current

          begin
            company = Mcp::QueryBuilders::CompanyQueryBuilder.find(id: id)

            unless company
              return MCP::Tool::Response.new([
                { type: "text", text: JSON.pretty_generate({ error: "Company not found", id: id }) }
              ])
            end

            data = Mcp::Serializers::CompanySerializer.serialize(company)

            latency_ms = ((Time.current - start_time) * 1000).round(2)
            Mcp::Logger.log_tool_execution(
              tool_name: "get_company",
              params: { id: id },
              latency_ms: latency_ms,
              success: true
            )

            MCP::Tool::Response.new([
              { type: "text", text: JSON.pretty_generate(data) }
            ])
          rescue => e
            Mcp::Logger.log_error(e, tool: "get_company", params: { id: id })
            raise
          end
        end
      end
    end
  end
end
