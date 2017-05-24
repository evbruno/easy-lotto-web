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

ActiveRecord::Schema.define(version: 20170523204245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "betting_pools", force: :cascade do |t|
    t.date "date"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_betting_pools_on_group_id"
  end

  create_table "draws", force: :cascade do |t|
    t.bigint "lottery_id"
    t.integer "number"
    t.date "date"
    t.text "numbers"
    t.text "prizes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lottery_id"], name: "index_draws_on_lottery_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lotteries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lottery_bets", force: :cascade do |t|
    t.bigint "betting_pool_id"
    t.integer "sequence"
    t.text "numbers"
    t.bigint "lottery_id"
    t.integer "first_draw"
    t.integer "last_draw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["betting_pool_id"], name: "index_lottery_bets_on_betting_pool_id"
    t.index ["lottery_id"], name: "index_lottery_bets_on_lottery_id"
  end

  create_table "user_balance_entries", force: :cascade do |t|
    t.bigint "user_group_id"
    t.float "value"
    t.date "date"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_group_id"], name: "index_user_balance_entries_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.boolean "admin", default: false
    t.float "balance", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "betting_pools", "groups"
  add_foreign_key "draws", "lotteries"
  add_foreign_key "lottery_bets", "betting_pools"
  add_foreign_key "lottery_bets", "lotteries"
  add_foreign_key "user_balance_entries", "user_groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
