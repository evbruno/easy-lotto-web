class AddValuesToBettingPool < ActiveRecord::Migration[5.1]
  def change
    add_column :betting_pools, :value, :float, null: false, default: 0
    add_column :betting_pools, :value_per_participant, :float, null: false, default: 0
    #add_column :betting_pools, :count_participants, :int, null: false, default: 0
  end
end
