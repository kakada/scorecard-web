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

ActiveRecord::Schema.define(version: 2020_10_27_062123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cafs", force: :cascade do |t|
    t.string "name"
    t.string "sex"
    t.string "date_of_birth"
    t.string "tel"
    t.string "address"
    t.integer "local_ngo_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.integer "program_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lft"], name: "index_categories_on_lft"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["rgt"], name: "index_categories_on_rgt"
  end

  create_table "custom_indicators", force: :cascade do |t|
    t.string "name"
    t.string "audio"
    t.string "tag"
    t.string "scorecard_uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "indicators", force: :cascade do |t|
    t.integer "categorizable_id"
    t.string "categorizable_type"
    t.string "tag"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "json_file"
    t.integer "program_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "languages_indicators", force: :cascade do |t|
    t.integer "language_id"
    t.string "language_code"
    t.integer "indicator_id"
    t.string "content"
    t.string "audio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "local_ngos", force: :cascade do |t|
    t.string "name"
    t.string "province_id", limit: 2
    t.string "district_id", limit: 4
    t.string "commune_id", limit: 6
    t.string "village_id", limit: 8
    t.string "address"
    t.integer "program_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", primary_key: "code", id: :string, force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_km", null: false
    t.string "kind", null: false
    t.string "parent_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "raised_indicators", force: :cascade do |t|
    t.integer "indicatorable_id"
    t.string "indicatorable_type"
    t.integer "raised_person_id"
    t.string "scorecard_uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "raised_people", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "gender"
    t.integer "age"
    t.boolean "disability", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "voting_indicator_id"
    t.integer "voting_person_id"
    t.string "scorecard_uuid"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scorecard_types", force: :cascade do |t|
    t.string "name"
    t.integer "program_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scorecards", force: :cascade do |t|
    t.string "uuid"
    t.integer "unit_type_id"
    t.integer "category_id"
    t.string "name"
    t.text "description"
    t.string "province_id", limit: 2
    t.string "district_id", limit: 4
    t.string "commune_id", limit: 6
    t.integer "year"
    t.datetime "conducted_date"
    t.integer "number_of_caf"
    t.integer "number_of_participant"
    t.integer "number_of_female"
    t.datetime "planned_start_date"
    t.datetime "planned_end_date"
    t.integer "status"
    t.integer "program_id"
    t.integer "local_ngo_id"
    t.integer "scorecard_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location_code"
  end

  create_table "scorecards_cafs", force: :cascade do |t|
    t.integer "caf_id"
    t.integer "scorecard_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.integer "program_id"
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
    t.integer "role"
    t.integer "program_id"
    t.string "authentication_token", default: ""
    t.datetime "token_expired_date"
    t.string "language_code", default: "en"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vote_people", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "gender"
    t.integer "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "voting_indicators", force: :cascade do |t|
    t.integer "indicatorable_id"
    t.string "indicatorable_type"
    t.string "scorecard_uuid"
    t.integer "median"
    t.text "strength"
    t.text "weakness"
    t.text "improvement"
    t.text "next_step"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "voting_people", force: :cascade do |t|
    t.string "scorecard_uuid"
    t.string "gender"
    t.integer "age"
    t.boolean "disability", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
