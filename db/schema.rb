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

ActiveRecord::Schema.define(version: 20160204060548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: :cascade do |t|
    t.date     "start_date",                    null: false
    t.date     "end_date"
    t.string   "address",                       null: false
    t.string   "title",                         null: false
    t.string   "link",                          null: false
    t.text     "blurb",                         null: false
    t.integer  "hours"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "venue",         default: "",    null: false
    t.boolean  "students_only", default: false, null: false
  end

  add_index "events", ["start_date"], name: "index_events_on_start_date", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "source"
    t.date     "date"
    t.string   "title"
    t.string   "location"
    t.string   "url"
    t.boolean  "reviewed",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "key"
  end

  add_index "leads", ["date"], name: "index_leads_on_date", using: :btree
  add_index "leads", ["key"], name: "index_leads_on_key", unique: true, using: :btree

end
