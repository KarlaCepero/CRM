# frozen_string_literal: true

module Mcp
  module QueryBuilders
    class NoteQueryBuilder
      def self.list(limit: 100, offset: 0)
        Note.includes(:notable)
            .limit([limit.to_i, 500].min)
            .offset(offset.to_i)
            .order(created_at: :desc)
      end

      def self.find(id:)
        Note.includes(:notable).find_by(id: id)
      end

      def self.list_for_notable(type:, id:)
        Note.includes(:notable)
            .where(notable_type: type, notable_id: id)
            .limit(100)
            .order(created_at: :desc)
      end
    end
  end
end
