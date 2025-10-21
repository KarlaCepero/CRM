class Deal < ApplicationRecord
  belongs_to :contact, optional: true
  belongs_to :company, optional: true
  has_many :activities, as: :activitable, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  validates :title, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :stage, inclusion: { in: %w[lead qualification proposal negotiation closed_won closed_lost] }

  STAGES = {
    "lead" => "Lead",
    "qualification" => "Qualification",
    "proposal" => "Proposal",
    "negotiation" => "Negotiation",
    "closed_won" => "Closed Won",
    "closed_lost" => "Closed Lost"
  }.freeze
end
