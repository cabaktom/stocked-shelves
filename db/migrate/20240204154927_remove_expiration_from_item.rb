class RemoveExpirationFromItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :expired, :boolean
  end
end
