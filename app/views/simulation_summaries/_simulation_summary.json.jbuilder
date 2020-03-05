json.extract! simulation_summary, :id, :simulation_id, :summarized_at, :created_at, :updated_at
json.url simulation_summary_url(simulation_summary, format: :json)
