class CreateLotteries < ActiveRecord::Migration[5.1]
  def change
    create_table :lotteries do |t|
      t.string :name

      t.timestamps
    end
  end
end
