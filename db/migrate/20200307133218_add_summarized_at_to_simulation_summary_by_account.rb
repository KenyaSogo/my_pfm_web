class AddSummarizedAtToSimulationSummaryByAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :simulation_summary_by_accounts, :summarized_at, :datetime, after: :memo
  end
end
