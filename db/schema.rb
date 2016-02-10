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

ActiveRecord::Schema.define(version: 20160210013203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bids", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.integer "price"
    t.integer "duration_estimate"
    t.text    "details"
    t.integer "status",            default: 0
  end

  add_index "bids", ["job_id"], name: "index_bids_on_job_id", using: :btree
  add_index "bids", ["user_id"], name: "index_bids_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.text     "description"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.text     "text"
    t.integer  "rating"
    t.integer  "job_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "comments", ["job_id"], name: "index_comments_on_job_id", using: :btree
  add_index "comments", ["recipient_id"], name: "index_comments_on_recipient_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.integer  "category_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "description"
    t.integer  "user_id"
    t.integer  "status",                default: 0
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.datetime "bidding_close_date"
    t.datetime "must_complete_by_date"
    t.integer  "duration_estimate"
  end

  add_index "jobs", ["category_id"], name: "index_jobs_on_category_id", using: :btree
  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "role",                     default: 0
    t.string   "email_address"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "slug"
    t.string   "file_upload_file_name"
    t.string   "file_upload_content_type"
    t.integer  "file_upload_file_size"
    t.datetime "file_upload_updated_at"
    t.text     "bio"
    t.string   "image_path"
  end

  add_foreign_key "bids", "jobs"
  add_foreign_key "bids", "users"
  add_foreign_key "comments", "jobs"
  add_foreign_key "comments", "users"
  add_foreign_key "jobs", "categories"
  add_foreign_key "jobs", "users"
end
