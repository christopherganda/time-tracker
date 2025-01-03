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

ActiveRecord::Schema[7.0].define(version: 2025_01_03_014113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clock_ins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "clocked_in_at", null: false
    t.boolean "is_clocked_out", default: false, null: false
    t.index ["user_id", "is_clocked_out"], name: "index_clock_ins_on_user_id_and_is_clocked_out"
    t.index ["user_id"], name: "index_clock_ins_on_user_id"
  end

  create_table "sleep_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "clock_in_id", null: false
    t.datetime "clocked_in_at", null: false
    t.datetime "clocked_out_at", null: false
    t.index ["clock_in_id"], name: "index_sleep_records_on_clock_in_id"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "user_follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_user_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_user_follows_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_user_follows_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
  end

  add_foreign_key "clock_ins", "users"
  add_foreign_key "sleep_records", "clock_ins"
  add_foreign_key "sleep_records", "users"
  add_foreign_key "user_follows", "users", column: "followee_id"
  add_foreign_key "user_follows", "users", column: "follower_id"
end
