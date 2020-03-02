json.extract! billing_activity, :id, :billing_account_id, :asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target, :created_at, :updated_at
json.url billing_activity_url(billing_activity, format: :json)
