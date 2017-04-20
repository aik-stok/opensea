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

ActiveRecord::Schema.define(version: 20170419142355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ports", force: :cascade do |t|
    t.string   "title"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", force: :cascade do |t|
    t.date     "opened_at"
    t.integer  "port_id"
    t.string   "shippable_type"
    t.integer  "shippable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["port_id"], name: "index_positions_on_port_id", using: :btree
    t.index ["shippable_type", "shippable_id"], name: "index_positions_on_shippable_type_and_shippable_id", using: :btree
  end

  create_table "shipments", force: :cascade do |t|
    t.string   "title"
    t.integer  "hold_capacity"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "ships", force: :cascade do |t|
    t.string   "title"
    t.integer  "hold_capacity"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "positions", "ports"
end
