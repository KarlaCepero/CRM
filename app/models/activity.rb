class Activity < ApplicationRecord
  belongs_to :activitable, polymorphic: true

  validates :activity_type, presence: true, inclusion: { in: %w[call email meeting task] }
  validates :description, presence: true
  validates :status, inclusion: { in: %w[pending completed cancelled] }

  TYPES = {
    "call" => "Call",
    "email" => "Email",
    "meeting" => "Meeting",
    "task" => "Task"
  }.freeze

  STATUSES = {
    "pending" => "Pending",
    "completed" => "Completed",
    "cancelled" => "Cancelled"
  }.freeze
end
