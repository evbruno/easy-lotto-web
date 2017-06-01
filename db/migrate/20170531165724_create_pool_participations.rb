class CreatePoolParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :pool_participations do |t|
      t.references :betting_pool, foreign_key: true
      t.references :user_group, foreign_key: true

      t.timestamps
    end
  end
end
