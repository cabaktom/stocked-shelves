class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.integer :days_before_expiration, null: false, default: 1
      t.boolean :by_email, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
