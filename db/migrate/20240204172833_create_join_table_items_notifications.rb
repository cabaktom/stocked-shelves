class CreateJoinTableItemsNotifications < ActiveRecord::Migration[7.1]
  def change
    create_join_table :items, :notifications do |t|
      t.index :item_id
      t.index :notification_id
    end
  end
end
