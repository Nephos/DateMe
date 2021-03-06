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

ActiveRecord::Schema.define(version: 20160406092948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "meeting_dates", force: :cascade do |t|
    t.datetime "date"
    t.uuid     "meeting_uuid"
    t.text     "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "meeting_dates", ["meeting_uuid", "date"], name: "index_meeting_dates_on_meeting_uuid_and_date", unique: true, using: :btree
  add_index "meeting_dates", ["meeting_uuid"], name: "index_meeting_dates_on_meeting_uuid", using: :btree

  create_table "meetings", force: :cascade do |t|
    t.string   "name",        limit: 64, null: false
    t.text     "description"
    t.datetime "end_at"
    t.integer  "user_id"
    t.uuid     "uuid",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "meetings", ["uuid"], name: "index_meetings_on_uuid", using: :btree

  create_table "user_dates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "meeting_date_id"
    t.string   "state",           limit: 8
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_dates", ["meeting_date_id"], name: "index_user_dates_on_meeting_date_id", using: :btree
  add_index "user_dates", ["user_id", "meeting_date_id"], name: "index_user_dates_on_user_id_and_meeting_date_id", unique: true, using: :btree
  add_index "user_dates", ["user_id"], name: "index_user_dates_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",          null: false
    t.string   "encrypted_password",                 default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.json     "roles",                              default: ["default"], null: false
    t.string   "name",                   limit: 8
  end

  add_foreign_key "user_dates", "meeting_dates"
  add_foreign_key "user_dates", "users"
end
