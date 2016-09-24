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

ActiveRecord::Schema.define(version: 20160914224833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actor_pages", force: :cascade do |t|
    t.integer  "actor_id"
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actor_websites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "actor_id"
    t.integer  "website_id"
  end

  create_table "actors", force: :cascade do |t|
    t.string   "token"
    t.date     "dateOfBirth"
    t.decimal  "hoursLoggedIn"
    t.decimal  "frequency"
    t.decimal  "experience"
    t.decimal  "percentile"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "kind"
  end

  create_table "movements", force: :cascade do |t|
    t.integer  "track_id"
    t.decimal  "x"
    t.decimal  "y"
    t.string   "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "page_id"
  end

  create_table "pageobjects", force: :cascade do |t|
    t.string   "selector"
    t.string   "href"
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "page_id"
    t.decimal  "width"
    t.decimal  "height"
    t.string   "tagid"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "host"
    t.string   "path"
    t.string   "href"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testjsons", force: :cascade do |t|
    t.string   "x"
    t.string   "y"
    t.string   "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "final"
    t.integer  "track"
  end

  create_table "tracks", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "actor_id"
    t.integer  "pageobject_id"
    t.decimal  "track_time"
    t.decimal  "track_x"
    t.decimal  "track_y"
  end

  create_table "user_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "page_id"
  end

  create_table "user_websites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "website_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "token"
  end

  create_table "websites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "host"
  end

end
