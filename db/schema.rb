# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150525154743) do

  create_table "alarms", force: :cascade do |t|
    t.string   "name",              limit: 32
    t.string   "callback_function", limit: 128
    t.integer  "minutes"
    t.boolean  "repeat"
    t.datetime "wake_at"
    t.integer  "bot_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "alarms", ["bot_id", "name"], name: "index_alarms_on_bot_id_and_name", unique: true
  add_index "alarms", ["bot_id"], name: "index_alarms_on_bot_id"
  add_index "alarms", ["wake_at"], name: "index_alarms_on_wake_at"

  create_table "bot_bot_modules", force: :cascade do |t|
    t.integer  "bot_id"
    t.integer  "bot_module_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "bot_bot_modules", ["bot_id"], name: "index_bot_bot_modules_on_bot_id"
  add_index "bot_bot_modules", ["bot_module_id"], name: "index_bot_bot_modules_on_bot_module_id"

  create_table "bot_modules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",        limit: 32
    t.string   "description", limit: 128
    t.text     "script"
    t.integer  "permission"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "bot_modules", ["user_id"], name: "index_bot_modules_on_user_id"

  create_table "bots", force: :cascade do |t|
    t.string   "name",          limit: 32
    t.string   "default_icon",  limit: 32
    t.string   "channel",       limit: 32
    t.string   "channel_id",    limit: 32
    t.text     "current_error"
    t.text     "script"
    t.integer  "permission"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "bots", ["user_id"], name: "index_bots_on_user_id"

  create_table "storages", force: :cascade do |t|
    t.integer  "bot_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "storages", ["bot_id"], name: "index_storages_on_bot_id"

  create_table "users", force: :cascade do |t|
    t.string   "uid",        limit: 128
    t.string   "name",       limit: 128
    t.string   "image_url",  limit: 512
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid"

end
