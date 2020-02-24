json.extract! simulation_result_activity, :id, :simulation_entry_detail_id, :asset_account_id, :transaction_date, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target, :created_at, :updated_at
json.url simulation_result_activity_url(simulation_result_activity, format: :json)
