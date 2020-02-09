json.extract! asset_activity, :id, :asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target, :created_at, :updated_at
json.url asset_activity_url(asset_activity, format: :json)
