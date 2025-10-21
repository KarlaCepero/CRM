# frozen_string_literal: true

module Mcp
  module Serializers
    class ActivitySerializer
      def self.serialize(activity)
        {
          id: activity.id,
          activity_type: activity.activity_type,
          activity_type_label: Activity::TYPES[activity.activity_type],
          description: activity.description,
          due_date: activity.due_date&.iso8601,
          status: activity.status,
          status_label: Activity::STATUSES[activity.status],
          activitable_type: activity.activitable_type,
          activitable_id: activity.activitable_id,
          activitable_name: activitable_name(activity),
          created_at: activity.created_at&.iso8601,
          updated_at: activity.updated_at&.iso8601
        }
      end

      def self.serialize_collection(activities)
        activities.map { |activity| serialize(activity) }
      end

      private

      def self.activitable_name(activity)
        case activity.activitable
        when Company
          activity.activitable.name
        when Contact
          activity.activitable.full_name
        when Deal
          activity.activitable.title
        else
          "Unknown"
        end
      end
    end
  end
end
