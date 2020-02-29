json.extract! billing_account, :id, :simulation_id, :credit_account_id, :billing_closing_day, :withdrawal_day, :withdrawal_month_offset, :billing_item_id, :billing_sub_item_id, :debit_account_id, :debit_item_id, :debit_sub_item_id, :created_at, :updated_at
json.url billing_account_url(billing_account, format: :json)
