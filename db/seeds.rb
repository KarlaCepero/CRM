# Clear existing data
puts "Clearing existing data..."
Note.destroy_all
Activity.destroy_all
Deal.destroy_all
Contact.destroy_all
Company.destroy_all

puts "Creating companies..."
companies = [
  { name: "Tech Solutions Inc", email: "contact@techsolutions.com", phone: "+1-555-0101", address: "123 Tech Street, San Francisco, CA 94105", website: "https://techsolutions.com", industry: "Technology" },
  { name: "Global Marketing Group", email: "info@globalmarketing.com", phone: "+1-555-0102", address: "456 Marketing Ave, New York, NY 10001", website: "https://globalmarketing.com", industry: "Marketing" },
  { name: "Finance Partners LLC", email: "contact@financepartners.com", phone: "+1-555-0103", address: "789 Finance Blvd, Chicago, IL 60601", website: "https://financepartners.com", industry: "Finance" },
  { name: "Healthcare Innovations", email: "hello@healthcareinnovations.com", phone: "+1-555-0104", address: "321 Health Dr, Boston, MA 02101", website: "https://healthcareinnovations.com", industry: "Healthcare" },
  { name: "Retail Express Co", email: "support@retailexpress.com", phone: "+1-555-0105", address: "654 Retail Way, Los Angeles, CA 90001", website: "https://retailexpress.com", industry: "Retail" }
]

created_companies = companies.map { |company| Company.create!(company) }

puts "Creating contacts..."
contacts_data = [
  { first_name: "John", last_name: "Smith", email: "john.smith@techsolutions.com", phone: "+1-555-1001", position: "CEO", company: created_companies[0] },
  { first_name: "Sarah", last_name: "Johnson", email: "sarah.johnson@techsolutions.com", phone: "+1-555-1002", position: "CTO", company: created_companies[0] },
  { first_name: "Michael", last_name: "Williams", email: "michael.williams@globalmarketing.com", phone: "+1-555-1003", position: "Marketing Director", company: created_companies[1] },
  { first_name: "Emily", last_name: "Brown", email: "emily.brown@globalmarketing.com", phone: "+1-555-1004", position: "Account Manager", company: created_companies[1] },
  { first_name: "David", last_name: "Jones", email: "david.jones@financepartners.com", phone: "+1-555-1005", position: "CFO", company: created_companies[2] },
  { first_name: "Lisa", last_name: "Davis", email: "lisa.davis@financepartners.com", phone: "+1-555-1006", position: "Financial Advisor", company: created_companies[2] },
  { first_name: "Robert", last_name: "Miller", email: "robert.miller@healthcareinnovations.com", phone: "+1-555-1007", position: "Operations Manager", company: created_companies[3] },
  { first_name: "Jennifer", last_name: "Wilson", email: "jennifer.wilson@retailexpress.com", phone: "+1-555-1008", position: "Sales Director", company: created_companies[4] }
]

created_contacts = contacts_data.map { |contact| Contact.create!(contact) }

puts "Creating deals..."
deals_data = [
  { title: "Enterprise Software License", amount: 50000.00, stage: "proposal", expected_close_date: 30.days.from_now, contact: created_contacts[0], company: created_companies[0] },
  { title: "Cloud Infrastructure Setup", amount: 75000.00, stage: "negotiation", expected_close_date: 45.days.from_now, contact: created_contacts[1], company: created_companies[0] },
  { title: "Marketing Campaign Q1", amount: 35000.00, stage: "qualification", expected_close_date: 20.days.from_now, contact: created_contacts[2], company: created_companies[1] },
  { title: "Annual Marketing Retainer", amount: 120000.00, stage: "closed_won", expected_close_date: 5.days.ago, contact: created_contacts[3], company: created_companies[1] },
  { title: "Financial Consulting Services", amount: 25000.00, stage: "lead", expected_close_date: 60.days.from_now, contact: created_contacts[4], company: created_companies[2] },
  { title: "Audit Services", amount: 40000.00, stage: "proposal", expected_close_date: 35.days.from_now, contact: created_contacts[5], company: created_companies[2] },
  { title: "Healthcare Management System", amount: 95000.00, stage: "negotiation", expected_close_date: 40.days.from_now, contact: created_contacts[6], company: created_companies[3] },
  { title: "Retail POS System", amount: 60000.00, stage: "closed_won", expected_close_date: 10.days.ago, contact: created_contacts[7], company: created_companies[4] },
  { title: "Inventory Management Software", amount: 45000.00, stage: "closed_lost", expected_close_date: 15.days.ago, contact: created_contacts[7], company: created_companies[4] }
]

created_deals = deals_data.map { |deal| Deal.create!(deal) }

puts "Creating activities..."
activities_data = [
  { activity_type: "call", description: "Follow up call about Enterprise Software License proposal", due_date: 2.days.from_now, status: "pending", activitable: created_deals[0] },
  { activity_type: "meeting", description: "Demo presentation for Cloud Infrastructure", due_date: 5.days.from_now, status: "pending", activitable: created_deals[1] },
  { activity_type: "email", description: "Send marketing campaign proposal", due_date: 1.day.from_now, status: "pending", activitable: created_deals[2] },
  { activity_type: "task", description: "Prepare contract documents", due_date: 3.days.from_now, status: "pending", activitable: created_deals[5] },
  { activity_type: "call", description: "Introduction call with new lead", due_date: Time.now, status: "pending", activitable: created_companies[2] },
  { activity_type: "meeting", description: "Quarterly business review", due_date: 7.days.from_now, status: "pending", activitable: created_companies[0] },
  { activity_type: "email", description: "Send thank you email after meeting", due_date: 1.day.ago, status: "completed", activitable: created_contacts[0] },
  { activity_type: "call", description: "Check-in call with client", due_date: 2.days.ago, status: "completed", activitable: created_contacts[3] }
]

created_activities = activities_data.map { |activity| Activity.create!(activity) }

puts "Creating notes..."
notes_data = [
  { content: "Client expressed strong interest in enterprise features. Mentioned they have budget approved for Q1.", notable: created_deals[0] },
  { content: "Need to follow up on technical requirements. CTO wants to see scalability benchmarks.", notable: created_deals[1] },
  { content: "Company is expanding to 3 new markets this year. Great opportunity for additional services.", notable: created_companies[0] },
  { content: "Contact mentioned they're evaluating 2 other vendors. Need to emphasize our unique value proposition.", notable: created_contacts[2] },
  { content: "Meeting went very well. They want to move forward with the proposal. Waiting on legal review.", notable: created_deals[3] },
  { content: "Client requested case studies from similar healthcare organizations.", notable: created_deals[6] },
  { content: "Lost deal due to budget constraints. Keep warm for potential opportunity next quarter.", notable: created_deals[8] },
  { content: "New decision maker introduced. Need to schedule separate meeting to present our solution.", notable: created_companies[3] }
]

notes_data.each { |note| Note.create!(note) }

puts "Seed data created successfully!"
puts "Summary:"
puts "- #{Company.count} companies"
puts "- #{Contact.count} contacts"
puts "- #{Deal.count} deals"
puts "- #{Activity.count} activities"
puts "- #{Note.count} notes"
