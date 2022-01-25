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

ActiveRecord::Schema.define(version: 2022_01_20_103343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "c_p_ts", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "modifier"
    t.float "charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cost_estimates", force: :cascade do |t|
    t.string "patient_name"
    t.datetime "date_of_appointment"
    t.string "plan_name"
    t.string "plan_type"
    t.float "co_pay"
    t.float "co_ins"
    t.float "deductable_balance"
    t.float "out_of_pocket_max_balance"
    t.integer "visit_template_id"
    t.integer "fee_schedule_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cpts", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "modifier"
    t.float "charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "coverage_type"
  end

  create_table "fee_schedules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "template_terminologies", force: :cascade do |t|
    t.integer "visit_template_id"
    t.integer "terminology_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "units"
  end

  create_table "terminologies", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "modifier"
    t.float "charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "coverage_type"
  end

  create_table "terminology_fee_schedules", force: :cascade do |t|
    t.integer "terminology_id"
    t.integer "fee_schedule_id"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visit_templates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "fee_schedule_id"
  end

end
