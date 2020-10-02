# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_01_091530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_issues", force: :cascade do |t|
    t.integer "raised_persion_id"
    t.text "content"
    t.string "audio"
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "issue_categories", force: :cascade do |t|
    t.string "sector"
    t.integer "scorecard_category"
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "issue_ratings", force: :cascade do |t|
    t.integer "vote_issue_id"
    t.integer "vote_person_id"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "predefined_issues", force: :cascade do |t|
    t.text "content"
    t.string "audio"
    t.integer "issue_category_id"
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "raised_issues", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.integer "raised_person_id"
    t.text "content"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "raised_people", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "gender"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scorecards", force: :cascade do |t|
    t.string "uuid"
    t.integer "conducted_year"
    t.datetime "conducted_date"
    t.string "province_code", limit: 2
    t.string "district_code", limit: 4
    t.string "commune_code", limit: 6
    t.integer "category"
    t.string "sector"
    t.integer "number_of_caf"
    t.integer "number_of_participant"
    t.integer "number_of_female"
    t.text "caf_members"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "swots", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.integer "voting_issue_id"
    t.integer "display_order"
    t.text "strength"
    t.text "weakness"
    t.text "improvement"
    t.text "activity"
    t.float "rating_median_score"
    t.string "rating_result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vote_issues", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "content"
    t.string "audio"
    t.string "display_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vote_people", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "gender"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
