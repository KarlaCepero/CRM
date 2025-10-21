# frozen_string_literal: true

module Mcp
  module Serializers
    class ContactSerializer
      def self.serialize(contact)
        {
          id: contact.id,
          first_name: contact.first_name,
          last_name: contact.last_name,
          full_name: contact.full_name,
          email: contact.email,
          phone: contact.phone,
          position: contact.position,
          company_id: contact.company_id,
          company_name: contact.company&.name,
          created_at: contact.created_at&.iso8601,
          updated_at: contact.updated_at&.iso8601,
          deals_count: contact.deals.size
        }
      end

      def self.serialize_collection(contacts)
        contacts.map { |contact| serialize(contact) }
      end
    end
  end
end
