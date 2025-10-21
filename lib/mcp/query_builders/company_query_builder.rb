# frozen_string_literal: true

module Mcp
  module QueryBuilders
    class CompanyQueryBuilder
      def self.list(limit: 100, offset: 0)
        Company.includes(:contacts, :deals)
               .limit([limit.to_i, 500].min) # Max 500 to prevent abuse
               .offset(offset.to_i)
               .order(created_at: :desc)
      end

      def self.find(id:)
        Company.includes(:contacts, :deals).find_by(id: id)
      end

      def self.search(query:)
        Company.includes(:contacts, :deals)
               .where("name LIKE ? OR email LIKE ?", "%#{sanitize(query)}%", "%#{sanitize(query)}%")
               .limit(50)
               .order(created_at: :desc)
      end

      def self.sanitize(query)
        query.to_s.gsub(/[%_]/, '\\\\\0')
      end
    end
  end
end
