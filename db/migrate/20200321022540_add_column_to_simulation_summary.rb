class AddColumnToSimulationSummary < ActiveRecord::Migration[5.0]
  def change
    add_reference :simulation_summaries, :main_breakdown_type, foreign_key: { to_table: :simulation_breakdown_types }, after: :summarized_at
    add_column :simulation_summaries, :main_breakdown_id, :integer, after: :main_breakdown_type_id
    add_reference :simulation_summaries, :main_section_type, foreign_key: { to_table: :simulation_section_types }, after: :main_breakdown_id
    add_column :simulation_summaries, :main_section_id, :integer, after: :main_section_type_id
    add_column :simulation_summaries, :search_from, :integer, after: :main_section_id
    add_column :simulation_summaries, :search_to, :integer, after: :search_from
  end
end
