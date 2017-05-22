class CreateDrawPrizes < ActiveRecord::Migration[5.1]
  def change
    create_table :draw_prizes do |t|
      t.references :draw, foreign_key: true
      t.integer :numbers
      t.float :value

      t.timestamps
    end
  end
end
