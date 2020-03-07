json.extract! simulation_summary_by_account, :id, :simulation_summary_id, :is_active, :memo, :created_at, :updated_at
json.url simulation_summary_by_account_url(simulation_summary_by_account, format: :json)
