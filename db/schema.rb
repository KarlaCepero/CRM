# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_16_172839) do
  create_table "activities", force: :cascade do |t|
    t.string "activity_type"
    t.text "description"
    t.datetime "due_date"
    t.string "status"
    t.string "activitable_type", null: false
    t.integer "activitable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activitable_type", "activitable_id"], name: "index_activities_on_activitable"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "website"
    t.string "industry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_companies_on_email"
    t.index ["name"], name: "index_companies_on_name"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "position"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
    t.index ["email"], name: "index_contacts_on_email"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["last_name"], name: "index_contacts_on_last_name"
  end

  create_table "deals", force: :cascade do |t|
    t.string "title"
    t.decimal "amount"
    t.string "stage"
    t.date "expected_close_date"
    t.integer "contact_id", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_deals_on_company_id"
    t.index ["contact_id"], name: "index_deals_on_contact_id"
    t.index ["created_at"], name: "index_deals_on_created_at"
    t.index ["stage"], name: "index_deals_on_stage"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.string "notable_type", null: false
    t.integer "notable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "deals", "companies"
  add_foreign_key "deals", "contacts"
end
