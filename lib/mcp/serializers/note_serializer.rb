# frozen_string_literal: true

module Mcp
  module Serializers
    class NoteSerializer
      def self.serialize(note)
        {
          id: note.id,
          content: note.content,
          notable_type: note.notable_type,
          notable_id: note.notable_id,
          notable_name: notable_name(note),
          created_at: note.created_at&.iso8601,
          updated_at: note.updated_at&.iso8601
        }
      end

      def self.serialize_collection(notes)
        notes.map { |note| serialize(note) }
      end

      private

      def self.notable_name(note)
        case note.notable
        when Company
          note.notable.name
        when Contact
          note.notable.full_name
        when Deal
          note.notable.title
        else
          "Unknown"
        end
      end
    end
  end
end
