# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_24_210742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "phone"
    t.string "email"
    t.string "url"
    t.integer "contactable_id"
    t.string "contactable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_id", "contactable_type"], name: "index_contacts_on_contactable_id_and_contactable_type", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "semester"
    t.integer "year"
    t.integer "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_courses_on_site_id"
  end

  create_table "fellows", force: :cascade do |t|
    t.string "key"
    t.string "first_name"
    t.string "last_name"
    t.integer "graduation_year"
    t.string "graduation_semester"
    t.integer "graduation_fiscal_year"
    t.text "interests_description"
    t.string "major"
    t.text "affiliations"
    t.decimal "gpa"
    t.string "linkedin_url"
    t.text "staff_notes"
    t.decimal "efficacy_score"
    t.integer "employment_status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employment_status_id"], name: "index_fellows_on_employment_status_id"
    t.index ["key"], name: "index_fellows_on_key", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sites_on_name", unique: true
  end

end
