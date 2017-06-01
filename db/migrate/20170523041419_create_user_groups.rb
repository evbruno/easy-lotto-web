class CreateUserGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :user_groups do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.boolean :admin, default: false
      t.float :balance, default: 0, null: false

      t.timestamps
    end
  end
end
