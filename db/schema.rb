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

ActiveRecord::Schema.define(version: 3) do

  create_table "freshmen", force: true do |t|
    t.string   "name"
    t.binary   "password_digest"
    t.boolean  "doing_packet"
    t.boolean  "on_packet"
    t.date     "start_date",         default: '2014-08-24'
    t.text     "info_directorships"
    t.text     "info_events"
    t.text     "info_achievements"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: true do |t|
    t.integer  "freshman_id"
    t.integer  "signer_id"
    t.string   "signer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signatures", ["freshman_id"], name: "index_signatures_on_freshman_id", using: :btree
  add_index "signatures", ["signer_id", "signer_type"], name: "index_signatures_on_signer_id_and_signer_type", using: :btree

  create_table "upperclassmen", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.boolean  "admin",      default: false
    t.boolean  "alumni"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
