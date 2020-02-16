json.extract! simulation_entry, :id, :simulation_id, :name, :simulation_entry_type_id, :apply_from, :apply_to, :created_at, :updated_at
json.url simulation_entry_url(simulation_entry, format: :json)
