class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.integer :track_id
      t.decimal :x
      t.decimal :y
      t.string :time

      t.timestamps null: false
    end
  end
end
