class AddDescriptionToUserBalanceEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :user_balance_entries, :description, :string
  end
end
