class CreateSimulationAcctClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :simulation_acct_classes do |t|
      t.references :sum_by_acct_class_setting, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
