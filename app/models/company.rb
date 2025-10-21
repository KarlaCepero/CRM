class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :deals, dependent: :destroy
  has_many :activities, as: :activitable, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
end
