class CreateUserBalanceEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :user_balance_entries do |t|
      t.references :user_group, foreign_key: true
      t.float :value
      t.date :date
      t.boolean :approved

      t.timestamps
    end
  end
end
