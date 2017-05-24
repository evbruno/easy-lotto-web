class CreateBettingPools < ActiveRecord::Migration[5.1]
  def change
    create_table :betting_pools do |t|
      t.date :date
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
