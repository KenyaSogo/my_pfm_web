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

ActiveRecord::Schema.define(version: 20200216161216) do

  create_table "asset_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "asset_id"
    t.integer  "asset_type_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["asset_id"], name: "index_asset_accounts_on_asset_id", using: :btree
    t.index ["asset_type_id"], name: "index_asset_accounts_on_asset_type_id", using: :btree
  end

  create_table "asset_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "asset_account_id"
    t.datetime "transaction_date"
    t.text     "description",           limit: 65535
    t.bigint   "amount"
    t.integer  "item_id"
    t.integer  "sub_item_id"
    t.boolean  "is_transfer"
    t.boolean  "is_calculation_target"
    t.string   "unique_key"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["asset_account_id"], name: "index_asset_activities_on_asset_account_id", using: :btree
    t.index ["item_id"], name: "index_asset_activities_on_item_id", using: :btree
    t.index ["sub_item_id"], name: "index_asset_activities_on_sub_item_id", using: :btree
  end

  create_table "asset_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name"
    t.datetime "last_aggregate_started_at"
    t.datetime "last_aggregate_succeeded_at"
    t.index ["user_id"], name: "index_assets_on_user_id", using: :btree
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "asset_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_items_on_asset_id", using: :btree
  end

  create_table "simulation_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_id"
    t.string   "name"
    t.integer  "simulation_entry_type_id"
    t.date     "apply_from"
    t.date     "apply_to"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["simulation_entry_type_id"], name: "index_simulation_entries_on_simulation_entry_type_id", using: :btree
    t.index ["simulation_id"], name: "index_simulation_entries_on_simulation_id", using: :btree
  end

  create_table "simulation_entry_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_entry_id"
    t.integer  "asset_account_id"
    t.integer  "transaction_date_year"
    t.integer  "transaction_date_month"
    t.integer  "transaction_date_day"
    t.integer  "transaction_date_weekday"
    t.text     "description",              limit: 65535
    t.bigint   "amount"
    t.integer  "item_id"
    t.integer  "sub_item_id"
    t.boolean  "is_transfer"
    t.boolean  "is_calculation_target"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["asset_account_id"], name: "index_simulation_entry_details_on_asset_account_id", using: :btree
    t.index ["item_id"], name: "index_simulation_entry_details_on_item_id", using: :btree
    t.index ["simulation_entry_id"], name: "index_simulation_entry_details_on_simulation_entry_id", using: :btree
    t.index ["sub_item_id"], name: "index_simulation_entry_details_on_sub_item_id", using: :btree
  end

  create_table "simulation_entry_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simulations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "asset_id"
    t.string   "name"
    t.datetime "last_generated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["asset_id"], name: "index_simulations_on_asset_id", using: :btree
  end

  create_table "sub_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "item_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_sub_items_on_item_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "user_name"
    t.string   "pfm_account_id"
    t.string   "encrypted_pfm_account_password"
    t.string   "encrypted_pfm_account_password_iv"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "asset_accounts", "asset_types"
  add_foreign_key "asset_accounts", "assets"
  add_foreign_key "asset_activities", "asset_accounts"
  add_foreign_key "asset_activities", "items"
  add_foreign_key "asset_activities", "sub_items"
  add_foreign_key "assets", "users"
  add_foreign_key "items", "assets"
  add_foreign_key "simulation_entries", "simulation_entry_types"
  add_foreign_key "simulation_entries", "simulations"
  add_foreign_key "simulation_entry_details", "asset_accounts"
  add_foreign_key "simulation_entry_details", "items"
  add_foreign_key "simulation_entry_details", "simulation_entries"
  add_foreign_key "simulation_entry_details", "sub_items"
  add_foreign_key "simulations", "assets"
  add_foreign_key "sub_items", "items"
end
