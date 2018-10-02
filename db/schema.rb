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

ActiveRecord::Schema.define(version: 2018_10_02_173138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "code"
    t.text "routes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.datetime "expires_at"
    t.index ["code"], name: "index_access_tokens_on_code", unique: true
    t.index ["owner_id", "owner_type"], name: "index_access_tokens_on_owner_id_and_owner_type"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "candidate_logs", force: :cascade do |t|
    t.integer "candidate_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_candidate_logs_on_candidate_id"
  end

  create_table "career_steps", force: :cascade do |t|
    t.integer "fellow_id"
    t.integer "position"
    t.string "name"
    t.string "description"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fellow_id"], name: "index_career_steps_on_fellow_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_coaches_on_name", unique: true
  end

  create_table "coaches_cohorts", id: false, force: :cascade do |t|
    t.bigint "coach_id", null: false
    t.bigint "cohort_id", null: false
    t.index ["coach_id"], name: "index_coaches_cohorts_on_coach_id"
    t.index ["cohort_id"], name: "index_coaches_cohorts_on_cohort_id"
  end

  create_table "coaches_employers", id: false, force: :cascade do |t|
    t.bigint "coach_id", null: false
    t.bigint "employer_id", null: false
    t.index ["coach_id"], name: "index_coaches_employers_on_coach_id"
    t.index ["employer_id"], name: "index_coaches_employers_on_employer_id"
  end

  create_table "cohort_fellows", force: :cascade do |t|
    t.decimal "grade", precision: 8, scale: 4
    t.decimal "attendance", precision: 8, scale: 4
    t.integer "nps_response"
    t.integer "endorsement"
    t.integer "professionalism"
    t.integer "teamwork"
    t.text "feedback"
    t.integer "fellow_id"
    t.integer "cohort_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id", "fellow_id"], name: "index_cohort_fellows_on_cohort_id_and_fellow_id", unique: true
  end

  create_table "cohorts", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_cohorts_on_course_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  end

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

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "employer_partner", default: false
    t.index ["employer_partner"], name: "index_employers_on_employer_partner"
    t.index ["name"], name: "index_employers_on_name", unique: true
  end

  create_table "employers_industries", id: false, force: :cascade do |t|
    t.bigint "industry_id", null: false
    t.bigint "employer_id", null: false
    t.index ["employer_id"], name: "index_employers_industries_on_employer_id"
    t.index ["industry_id"], name: "index_employers_industries_on_industry_id"
  end

  create_table "employment_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_employment_statuses_on_name", unique: true
    t.index ["position"], name: "index_employment_statuses_on_position", unique: true
  end

  create_table "fellow_opportunities", force: :cascade do |t|
    t.date "secured_on"
    t.text "staff_notes"
    t.integer "fellow_id"
    t.integer "opportunity_id"
    t.integer "opportunity_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "active"
    t.datetime "last_contact_at"
    t.index ["active"], name: "index_fellow_opportunities_on_active"
    t.index ["deleted_at"], name: "index_fellow_opportunities_on_deleted_at"
    t.index ["fellow_id", "opportunity_id"], name: "index_fellow_opportunities_on_fellow_id_and_opportunity_id", unique: true
    t.index ["opportunity_stage_id"], name: "index_fellow_opportunities_on_opportunity_stage_id"
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
    t.integer "user_id"
    t.boolean "receive_opportunities", default: true
    t.integer "portal_course_id"
    t.integer "portal_user_id"
    t.index ["employment_status_id"], name: "index_fellows_on_employment_status_id"
    t.index ["key"], name: "index_fellows_on_key", unique: true
    t.index ["receive_opportunities"], name: "index_fellows_on_receive_opportunities"
    t.index ["user_id"], name: "index_fellows_on_user_id"
  end

  create_table "fellows_industries", id: false, force: :cascade do |t|
    t.bigint "fellow_id", null: false
    t.bigint "industry_id", null: false
    t.index ["fellow_id"], name: "index_fellows_industries_on_fellow_id"
    t.index ["industry_id"], name: "index_fellows_industries_on_industry_id"
  end

  create_table "fellows_interests", id: false, force: :cascade do |t|
    t.bigint "fellow_id", null: false
    t.bigint "interest_id", null: false
    t.index ["fellow_id"], name: "index_fellows_interests_on_fellow_id"
    t.index ["interest_id"], name: "index_fellows_interests_on_interest_id"
  end

  create_table "fellows_majors", id: false, force: :cascade do |t|
    t.bigint "fellow_id", null: false
    t.bigint "major_id", null: false
    t.index ["fellow_id", "major_id"], name: "index_fellows_majors_on_fellow_id_and_major_id"
    t.index ["major_id", "fellow_id"], name: "index_fellows_majors_on_major_id_and_fellow_id"
  end

  create_table "fellows_metros", id: false, force: :cascade do |t|
    t.bigint "fellow_id", null: false
    t.bigint "metro_id", null: false
    t.index ["fellow_id"], name: "index_fellows_metros_on_fellow_id"
    t.index ["metro_id"], name: "index_fellows_metros_on_metro_id"
  end

  create_table "fellows_opportunity_types", id: false, force: :cascade do |t|
    t.bigint "fellow_id", null: false
    t.bigint "opportunity_type_id", null: false
    t.index ["fellow_id"], name: "index_fellows_opportunity_types_on_fellow_id"
    t.index ["opportunity_type_id"], name: "index_fellows_opportunity_types_on_opportunity_type_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_industries_on_name", unique: true
  end

  create_table "industries_opportunities", id: false, force: :cascade do |t|
    t.bigint "industry_id", null: false
    t.bigint "opportunity_id", null: false
    t.index ["industry_id"], name: "index_industries_opportunities_on_industry_id"
    t.index ["opportunity_id"], name: "index_industries_opportunities_on_opportunity_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_interests_on_name", unique: true
  end

  create_table "interests_opportunities", id: false, force: :cascade do |t|
    t.bigint "interest_id", null: false
    t.bigint "opportunity_id", null: false
    t.index ["interest_id"], name: "index_interests_opportunities_on_interest_id"
    t.index ["opportunity_id"], name: "index_interests_opportunities_on_opportunity_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "locateable_id"
    t.string "locateable_type"
    t.index ["locateable_id", "locateable_type"], name: "index_locations_on_locateable_id_and_locateable_type"
  end

  create_table "locations_opportunities", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "opportunity_id", null: false
    t.index ["location_id"], name: "index_locations_opportunities_on_location_id"
    t.index ["opportunity_id"], name: "index_locations_opportunities_on_opportunity_id"
  end

  create_table "majors", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_majors_on_name", unique: true
    t.index ["parent_id"], name: "index_majors_on_parent_id"
  end

  create_table "majors_opportunities", id: false, force: :cascade do |t|
    t.bigint "major_id", null: false
    t.bigint "opportunity_id", null: false
    t.index ["major_id", "opportunity_id"], name: "index_majors_opportunities_on_major_id_and_opportunity_id"
    t.index ["opportunity_id", "major_id"], name: "index_majors_opportunities_on_opportunity_id_and_major_id"
  end

  create_table "metro_relationships", id: false, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.index ["child_id"], name: "index_metro_relationships_on_child_id"
    t.index ["parent_id", "child_id"], name: "index_metro_relationships_on_parent_id_and_child_id"
    t.index ["parent_id"], name: "index_metro_relationships_on_parent_id"
  end

  create_table "metros", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.string "state"
    t.index ["code"], name: "index_metros_on_code", unique: true
    t.index ["name"], name: "index_metros_on_name", unique: true
    t.index ["source"], name: "index_metros_on_source"
    t.index ["state"], name: "index_metros_on_state"
  end

  create_table "metros_opportunities", id: false, force: :cascade do |t|
    t.bigint "metro_id", null: false
    t.bigint "opportunity_id", null: false
    t.index ["metro_id"], name: "index_metros_opportunities_on_metro_id"
    t.index ["opportunity_id"], name: "index_metros_opportunities_on_opportunity_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string "name"
    t.text "summary"
    t.integer "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "job_posting_url"
    t.date "application_deadline"
    t.text "steps"
    t.boolean "inbound", default: false
    t.boolean "recurring", default: false
    t.integer "opportunity_type_id"
    t.integer "region_id"
    t.boolean "published", default: false
    t.text "how_to_apply"
    t.integer "priority", default: 1000
    t.index ["employer_id"], name: "index_opportunities_on_employer_id"
    t.index ["inbound"], name: "index_opportunities_on_inbound"
    t.index ["opportunity_type_id"], name: "index_opportunities_on_opportunity_type_id"
    t.index ["priority"], name: "index_opportunities_on_priority"
    t.index ["published"], name: "index_opportunities_on_published"
    t.index ["recurring"], name: "index_opportunities_on_recurring"
    t.index ["region_id"], name: "index_opportunities_on_region_id"
  end

  create_table "opportunity_stages", force: :cascade do |t|
    t.string "name"
    t.decimal "probability", precision: 8, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "togglable"
    t.boolean "auto_notify", default: true
    t.boolean "active_status", default: true
    t.index ["name"], name: "index_opportunity_stages_on_name", unique: true
    t.index ["togglable"], name: "index_opportunity_stages_on_togglable"
  end

  create_table "opportunity_types", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_opportunity_types_on_name"
    t.index ["position"], name: "index_opportunity_types_on_position"
  end

  create_table "postal_codes", force: :cascade do |t|
    t.string "code"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "msa_code"
    t.string "city"
    t.string "state"
    t.index ["code"], name: "index_postal_codes_on_code"
    t.index ["state"], name: "index_postal_codes_on_state"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["name"], name: "index_regions_on_name"
    t.index ["position"], name: "index_regions_on_position"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_sites_on_code"
    t.index ["name"], name: "index_sites_on_name", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.date "due_at"
    t.boolean "completed", default: false
    t.text "notes"
    t.integer "taskable_id"
    t.string "taskable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed"], name: "index_tasks_on_completed"
    t.index ["due_at"], name: "index_tasks_on_due_at"
    t.index ["taskable_id", "taskable_type"], name: "index_tasks_on_taskable_id_and_taskable_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_administrator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
    t.boolean "is_fellow", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_admin"], name: "index_users_on_is_admin"
    t.index ["is_fellow"], name: "index_users_on_is_fellow"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
