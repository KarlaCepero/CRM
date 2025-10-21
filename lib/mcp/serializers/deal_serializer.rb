# frozen_string_literal: true

module Mcp
  module Serializers
    class DealSerializer
      def self.serialize(deal)
        {
          id: deal.id,
          title: deal.title,
          amount: deal.amount&.to_f,
          stage: deal.stage,
          stage_label: Deal::STAGES[deal.stage],
          expected_close_date: deal.expected_close_date&.iso8601,
          contact_id: deal.contact_id,
          contact_name: deal.contact&.full_name,
          company_id: deal.company_id,
          company_name: deal.company&.name,
          created_at: deal.created_at&.iso8601,
          updated_at: deal.updated_at&.iso8601
        }
      end

      def self.serialize_collection(deals)
        deals.map { |deal| serialize(deal) }
      end
    end
  end
end
