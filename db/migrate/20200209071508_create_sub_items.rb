class CreateSubItems < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_items do |t|
      t.references :item, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
