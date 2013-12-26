class AddUserIdToTransactions < ActiveRecord::Migration
  def up
    add_column    :transactions, :user_id, :string, null: false, default: ':nobody'
    change_column_default(:transactions, :user_id, nil)
    add_index     :transactions, [:app_id, :user_id, :key]
    remove_index  :transactions, [:app_id, :key]
  end

  def down
    add_index     :transactions, [:app_id, :key]
    remove_index  :transactions, [:app_id, :user_id, :key]
    remove_column :transactions, :user_id
  end
end
