# frozen_string_literal: true

module Mcp
  module QueryBuilders
    class ActivityQueryBuilder
      def self.list(limit: 100, offset: 0)
        Activity.includes(:activitable)
                .limit([limit.to_i, 500].min)
                .offset(offset.to_i)
                .order(created_at: :desc)
      end

      def self.find(id:)
        Activity.includes(:activitable).find_by(id: id)
      end

      def self.list_for_activitable(type:, id:)
        Activity.includes(:activitable)
                .where(activitable_type: type, activitable_id: id)
                .limit(100)
                .order(created_at: :desc)
      end
    end
  end
end
