class CreateDraws < ActiveRecord::Migration[5.1]
  def change
    create_table :draws do |t|
      t.references :lottery, foreign_key: true
      t.integer :number
      t.date :date
      t.text :numbers
      t.text :prizes

      t.timestamps
    end
  end
end
