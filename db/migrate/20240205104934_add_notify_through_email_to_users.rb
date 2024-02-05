class AddNotifyThroughEmailToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :notify_through_email, :boolean, default: true
  end
end
