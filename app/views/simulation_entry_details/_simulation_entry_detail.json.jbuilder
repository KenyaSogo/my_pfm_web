json.extract! simulation_entry_detail, :id, :simulation_entry_id, :asset_account_id, :transaction_date_year, :transaction_date_month, :transaction_date_day, :transaction_date_weekday, :description, :amount, :item_id, :sub_item_id, :is_transfer, :is_calculation_target, :created_at, :updated_at
json.url simulation_entry_detail_url(simulation_entry_detail, format: :json)
