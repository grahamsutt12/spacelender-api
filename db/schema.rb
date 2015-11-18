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

ActiveRecord::Schema.define(version: 20151118042606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "caption"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "file_name"
    t.string   "url"
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "listings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",      default: true
    t.string   "token"
  end

  add_index "listings", ["slug"], name: "index_listings_on_slug", using: :btree
  add_index "listings", ["user_id"], name: "index_listings_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "locations", ["listing_id"], name: "index_locations_on_listing_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "sender_id"
    t.string   "receiver_id"
    t.integer  "status",      default: 0
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "reservation_id"
    t.string   "payer_id"
    t.string   "payee_id"
    t.float    "amount"
    t.float    "fee"
    t.string   "card"
    t.integer  "status",         default: 0
    t.string   "token"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "charge"
  end

  add_index "payments", ["reservation_id"], name: "index_payments_on_reservation_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "time_type"
  end

  add_index "rates", ["rateable_type", "rateable_id"], name: "index_rates_on_rateable_type_and_rateable_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ref_token"
    t.text     "explanation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reports", ["ref_token"], name: "index_reports_on_ref_token", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "listing_id"
    t.datetime "start"
    t.datetime "end"
    t.string   "token"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "reason"
    t.string   "booked_by"
  end

  add_index "reservations", ["booked_by"], name: "index_reservations_on_booked_by", using: :btree
  add_index "reservations", ["listing_id"], name: "index_reservations_on_listing_id", using: :btree
  add_index "reservations", ["token"], name: "index_reservations_on_token", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "password_salt"
    t.integer  "role",             default: 0
    t.string   "auth_token"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "confirm_token"
    t.boolean  "active",           default: false
    t.string   "slug"
    t.string   "merchant_account"
    t.string   "access_code"
    t.string   "publishable_key"
    t.string   "customer_token"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  add_foreign_key "listings", "users"
  add_foreign_key "locations", "listings"
  add_foreign_key "payments", "reservations"
  add_foreign_key "reports", "users"
  add_foreign_key "reservations", "listings"
end
