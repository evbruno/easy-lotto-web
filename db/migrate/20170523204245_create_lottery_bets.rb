class CreateLotteryBets < ActiveRecord::Migration[5.1]
  def change
    create_table :lottery_bets do |t|
      t.references :betting_pool, foreign_key: true
      t.integer :sequence
      t.text :numbers
      t.references :lottery, foreign_key: true
      t.integer :first_draw
      t.integer :last_draw

      t.timestamps
    end
  end
end
