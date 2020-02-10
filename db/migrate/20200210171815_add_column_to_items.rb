class AddColumnToItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :items, :asset, foreign_key: true, after: :user_id
  end
end
