# frozen_string_literal: true

module Mcp
  module Serializers
    class CompanySerializer
      def self.serialize(company)
        {
          id: company.id,
          name: company.name,
          email: company.email,
          phone: company.phone,
          address: company.address,
          website: company.website,
          industry: company.industry,
          created_at: company.created_at&.iso8601,
          updated_at: company.updated_at&.iso8601,
          contacts_count: company.contacts.size,
          deals_count: company.deals.size
        }
      end

      def self.serialize_collection(companies)
        companies.map { |company| serialize(company) }
      end
    end
  end
end
