class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :app_id, null: false
      t.string :key,    null: false
      t.string :value,  null: true
      t.datetime :created_at
      t.index [:app_id, :key]
    end
  end
end
