class HomeController < ApplicationController
  def dashboard
    @companies_count = Company.count
    @contacts_count = Contact.count
    @deals_count = Deal.count
    @activities_count = Activity.count

    @recent_companies = Company.order(created_at: :desc).limit(5)
    @recent_contacts = Contact.order(created_at: :desc).limit(5)
    @recent_deals = Deal.order(created_at: :desc).limit(5)
    @pending_activities = Activity.where(status: "pending").order(due_date: :asc).limit(10)

    @total_deal_value = Deal.sum(:amount)
    @won_deals_value = Deal.where(stage: "closed_won").sum(:amount)
  end
end
