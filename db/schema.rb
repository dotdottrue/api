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

ActiveRecord::Schema.define(version: 20150512183908) do

  create_table "messages", force: :cascade do |t|
    t.integer  "identity"
    t.text     "cipher"
    t.integer  "iv"
    t.string   "key_recipient_enc"
    t.string   "sig_recipient"
    t.string   "recipient"
    t.string   "sig_service"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "identity"
    t.string   "password"
    t.integer  "salt_masterkey"
    t.string   "pubkey_user"
    t.string   "privkey_user_enc"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
