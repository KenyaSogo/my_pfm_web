class CreateSimulations < ActiveRecord::Migration[5.0]
  def change
    create_table :simulations do |t|
      t.references :asset, foreign_key: true
      t.string :name
      t.datetime :last_generated_at

      t.timestamps
    end
  end
end
