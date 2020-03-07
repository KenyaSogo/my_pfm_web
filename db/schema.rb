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

ActiveRecord::Schema.define(version: 20200307151057) do

  create_table "asset_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "asset_id"
    t.integer  "asset_type_id"
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.bigint   "initial_balance"
    t.datetime "initial_balance_base_date"
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

  create_table "billing_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_id"
    t.integer  "credit_account_id"
    t.integer  "billing_closing_day"
    t.integer  "withdrawal_day"
    t.integer  "withdrawal_month_offset"
    t.integer  "billing_item_id"
    t.integer  "billing_sub_item_id"
    t.integer  "debit_account_id"
    t.integer  "debit_item_id"
    t.integer  "debit_sub_item_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["billing_item_id"], name: "index_billing_accounts_on_billing_item_id", using: :btree
    t.index ["billing_sub_item_id"], name: "index_billing_accounts_on_billing_sub_item_id", using: :btree
    t.index ["credit_account_id"], name: "index_billing_accounts_on_credit_account_id", using: :btree
    t.index ["debit_account_id"], name: "index_billing_accounts_on_debit_account_id", using: :btree
    t.index ["debit_item_id"], name: "index_billing_accounts_on_debit_item_id", using: :btree
    t.index ["debit_sub_item_id"], name: "index_billing_accounts_on_debit_sub_item_id", using: :btree
    t.index ["simulation_id"], name: "index_billing_accounts_on_simulation_id", using: :btree
  end

  create_table "billing_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "billing_account_id"
    t.integer  "asset_account_id"
    t.date     "transaction_date"
    t.text     "description",           limit: 65535
    t.bigint   "amount"
    t.integer  "item_id"
    t.integer  "sub_item_id"
    t.boolean  "is_transfer"
    t.boolean  "is_calculation_target"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["asset_account_id"], name: "index_billing_activities_on_asset_account_id", using: :btree
    t.index ["billing_account_id"], name: "index_billing_activities_on_billing_account_id", using: :btree
    t.index ["item_id"], name: "index_billing_activities_on_item_id", using: :btree
    t.index ["sub_item_id"], name: "index_billing_activities_on_sub_item_id", using: :btree
  end

  create_table "billing_complement_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "billing_account_id"
    t.integer  "asset_account_id"
    t.date     "transaction_date"
    t.text     "description",           limit: 65535
    t.bigint   "amount"
    t.integer  "item_id"
    t.integer  "sub_item_id"
    t.boolean  "is_transfer"
    t.boolean  "is_calculation_target"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["asset_account_id"], name: "index_billing_complement_activities_on_asset_account_id", using: :btree
    t.index ["billing_account_id"], name: "index_billing_complement_activities_on_billing_account_id", using: :btree
    t.index ["item_id"], name: "index_billing_complement_activities_on_item_id", using: :btree
    t.index ["sub_item_id"], name: "index_billing_complement_activities_on_sub_item_id", using: :btree
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

  create_table "simulation_result_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_entry_detail_id"
    t.integer  "asset_account_id"
    t.date     "transaction_date"
    t.text     "description",                limit: 65535
    t.bigint   "amount"
    t.integer  "item_id"
    t.integer  "sub_item_id"
    t.boolean  "is_transfer"
    t.boolean  "is_calculation_target"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["asset_account_id"], name: "index_simulation_result_activities_on_asset_account_id", using: :btree
    t.index ["item_id"], name: "index_simulation_result_activities_on_item_id", using: :btree
    t.index ["simulation_entry_detail_id"], name: "index_simulation_result_activities_on_simulation_entry_detail_id", using: :btree
    t.index ["sub_item_id"], name: "index_simulation_result_activities_on_sub_item_id", using: :btree
  end

  create_table "simulation_summaries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_id"
    t.datetime "summarized_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["simulation_id"], name: "index_simulation_summaries_on_simulation_id", using: :btree
  end

  create_table "simulation_summary_by_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_summary_id"
    t.boolean  "is_active"
    t.text     "memo",                  limit: 65535
    t.datetime "summarized_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["simulation_summary_id"], name: "index_simulation_summary_by_accounts_on_simulation_summary_id", using: :btree
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

  create_table "sum_account_dailies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "simulation_summary_by_account_id"
    t.date     "base_date"
    t.integer  "asset_account_id"
    t.bigint   "balance"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["asset_account_id"], name: "index_sum_account_dailies_on_asset_account_id", using: :btree
    t.index ["simulation_summary_by_account_id"], name: "index_sum_account_dailies_on_simulation_summary_by_account_id", using: :btree
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
  add_foreign_key "billing_accounts", "asset_accounts", column: "credit_account_id"
  add_foreign_key "billing_accounts", "asset_accounts", column: "debit_account_id"
  add_foreign_key "billing_accounts", "items", column: "billing_item_id"
  add_foreign_key "billing_accounts", "items", column: "debit_item_id"
  add_foreign_key "billing_accounts", "simulations"
  add_foreign_key "billing_accounts", "sub_items", column: "billing_sub_item_id"
  add_foreign_key "billing_accounts", "sub_items", column: "debit_sub_item_id"
  add_foreign_key "billing_activities", "asset_accounts"
  add_foreign_key "billing_activities", "billing_accounts"
  add_foreign_key "billing_activities", "items"
  add_foreign_key "billing_activities", "sub_items"
  add_foreign_key "billing_complement_activities", "asset_accounts"
  add_foreign_key "billing_complement_activities", "billing_accounts"
  add_foreign_key "billing_complement_activities", "items"
  add_foreign_key "billing_complement_activities", "sub_items"
  add_foreign_key "items", "assets"
  add_foreign_key "simulation_entries", "simulation_entry_types"
  add_foreign_key "simulation_entries", "simulations"
  add_foreign_key "simulation_entry_details", "asset_accounts"
  add_foreign_key "simulation_entry_details", "items"
  add_foreign_key "simulation_entry_details", "simulation_entries"
  add_foreign_key "simulation_entry_details", "sub_items"
  add_foreign_key "simulation_result_activities", "asset_accounts"
  add_foreign_key "simulation_result_activities", "items"
  add_foreign_key "simulation_result_activities", "simulation_entry_details"
  add_foreign_key "simulation_result_activities", "sub_items"
  add_foreign_key "simulation_summaries", "simulations"
  add_foreign_key "simulation_summary_by_accounts", "simulation_summaries"
  add_foreign_key "simulations", "assets"
  add_foreign_key "sub_items", "items"
  add_foreign_key "sum_account_dailies", "asset_accounts"
  add_foreign_key "sum_account_dailies", "simulation_summary_by_accounts"
end
