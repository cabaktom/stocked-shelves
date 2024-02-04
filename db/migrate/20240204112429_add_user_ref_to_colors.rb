class AddUserRefToColors < ActiveRecord::Migration[7.1]
  def change
    add_reference :colors, :user, null: false, foreign_key: true
  end
end
