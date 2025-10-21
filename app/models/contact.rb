class Contact < ApplicationRecord
  belongs_to :company, optional: true
  has_many :deals, dependent: :destroy
  has_many :activities, as: :activitable, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  def full_name
    "#{first_name} #{last_name}"
  end
end
