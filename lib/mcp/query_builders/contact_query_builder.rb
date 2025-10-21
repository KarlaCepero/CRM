# frozen_string_literal: true

module Mcp
  module QueryBuilders
    class ContactQueryBuilder
      def self.list(limit: 100, offset: 0)
        Contact.includes(:company, :deals)
               .limit([limit.to_i, 500].min)
               .offset(offset.to_i)
               .order(created_at: :desc)
      end

      def self.find(id:)
        Contact.includes(:company, :deals).find_by(id: id)
      end

      def self.search(query:)
        Contact.includes(:company, :deals)
               .where(
                 "first_name LIKE ? OR last_name LIKE ? OR email LIKE ?",
                 "%#{sanitize(query)}%",
                 "%#{sanitize(query)}%",
                 "%#{sanitize(query)}%"
               )
               .limit(50)
               .order(created_at: :desc)
      end

      def self.sanitize(query)
        query.to_s.gsub(/[%_]/, '\\\\\0')
      end
    end
  end
end
