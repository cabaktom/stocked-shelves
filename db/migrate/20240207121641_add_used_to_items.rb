class AddUsedToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :used, :boolean, default: false
  end
end
