class AddNotNullToUsers < ActiveRecord::Migration[5.2]
  def up
    change_column_null :users, :account, false
    change_column_null :users, :name, false
  end

  def down
    change_column_null :users, :account, true
    change_column_null :users, :name, true
  end
end
