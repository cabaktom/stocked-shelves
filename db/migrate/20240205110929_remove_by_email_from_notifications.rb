class RemoveByEmailFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :notifications, :by_email, :boolean
  end
end
