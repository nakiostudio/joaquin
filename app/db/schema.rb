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

ActiveRecord::Schema.define(version: 20170411105541) do

  create_table "job_types", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "slug",       default: "", null: false
    t.string   "name",       default: "", null: false
  end

  add_index "job_types", ["slug"], name: "index_job_types_on_slug", unique: true

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "token",       default: "", null: false
    t.integer  "status",      default: 0,  null: false
    t.string   "alias"
    t.string   "os"
    t.string   "arch"
    t.string   "system"
    t.string   "local_host"
    t.string   "ip_address"
    t.string   "shell"
    t.string   "user"
    t.string   "home_dir"
    t.string   "port"
    t.string   "public_host"
    t.datetime "last_active"
  end

  add_index "nodes", ["token"], name: "index_nodes_on_token", unique: true

  create_table "step_types", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "slug",        default: "", null: false
    t.string   "name",        default: "", null: false
    t.string   "script",      default: "", null: false
    t.string   "plugin_data"
    t.integer  "job_type_id"
  end

  add_index "step_types", ["job_type_id"], name: "index_step_types_on_job_type_id"
  add_index "step_types", ["slug"], name: "index_step_types_on_slug", unique: true

  create_table "steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
