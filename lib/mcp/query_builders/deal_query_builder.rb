# frozen_string_literal: true

module Mcp
  module QueryBuilders
    class DealQueryBuilder
      def self.list(limit: 100, offset: 0)
        Deal.includes(:contact, :company)
            .limit([limit.to_i, 500].min)
            .offset(offset.to_i)
            .order(created_at: :desc)
      end

      def self.find(id:)
        Deal.includes(:contact, :company).find_by(id: id)
      end

      def self.search(query:)
        Deal.includes(:contact, :company)
            .where("title LIKE ?", "%#{sanitize(query)}%")
            .limit(50)
            .order(created_at: :desc)
      end

      def self.filter_by_stage(stage:)
        raise ArgumentError, "Invalid stage" unless Deal::STAGES.key?(stage)

        Deal.includes(:contact, :company)
            .where(stage: stage)
            .limit(100)
            .order(created_at: :desc)
      end

      def self.sanitize(query)
        query.to_s.gsub(/[%_]/, '\\\\\0')
      end
    end
  end
end
