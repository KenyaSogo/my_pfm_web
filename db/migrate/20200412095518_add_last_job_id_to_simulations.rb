class AddLastJobIdToSimulations < ActiveRecord::Migration[5.0]
  def change
    add_column :simulations, :last_job_id, :string, after: :last_generated_at
  end
end
